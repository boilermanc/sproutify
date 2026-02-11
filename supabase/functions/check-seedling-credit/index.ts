import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from "jsr:@supabase/supabase-js@2"
import { corsHeaders } from "../_shared/cors.ts"

Deno.serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders })
  }

  if (req.method !== "POST") {
    return new Response(
      JSON.stringify({ error: "Method not allowed" }),
      { status: 405, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    )
  }

  // Validate API key
  const apiKey = req.headers.get("x-api-key")
  const expectedKey = Deno.env.get("SEEDLING_SITE_API_KEY")

  if (!expectedKey || apiKey !== expectedKey) {
    return new Response(
      JSON.stringify({ error: "Unauthorized" }),
      { status: 401, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    )
  }

  // Initialize Supabase client with service role
  const supabaseUrl = Deno.env.get("SUPABASE_URL")!
  const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
  const supabase = createClient(supabaseUrl, supabaseServiceKey)

  try {
    const { action, email, order_id } = await req.json()

    if (!action || !email) {
      return new Response(
        JSON.stringify({ error: "Missing required fields: action, email" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      )
    }

    // Look up user by email (case-insensitive)
    const { data: profile, error: profileError } = await supabase
      .from("profiles")
      .select("id")
      .ilike("email", email.toLowerCase())
      .maybeSingle()

    if (profileError) {
      return new Response(
        JSON.stringify({ error: "Error looking up user", details: profileError.message }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      )
    }

    if (!profile) {
      return new Response(
        JSON.stringify({ error: "User not found" }),
        { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      )
    }

    const userId = profile.id

    if (action === "check") {
      const { data: credit, error: creditError } = await supabase
        .from("seedling_credits")
        .select("id, credit_amount, expires_at, subscription_tier")
        .eq("user_id", userId)
        .eq("status", "active")
        .gt("expires_at", new Date().toISOString())
        .order("created_at", { ascending: true })
        .limit(1)
        .maybeSingle()

      if (creditError) {
        return new Response(
          JSON.stringify({ error: "Error checking credit", details: creditError.message }),
          { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
        )
      }

      return new Response(
        JSON.stringify({
          has_credit: !!credit,
          credit_id: credit?.id ?? null,
          credit_amount: credit?.credit_amount ?? 0,
          expires_at: credit?.expires_at ?? null,
          subscription_tier: credit?.subscription_tier ?? null,
          is_lifetime: credit?.subscription_tier === "lifetime",
        }),
        { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      )
    }

    if (action === "redeem") {
      if (!order_id) {
        return new Response(
          JSON.stringify({ error: "Missing required field: order_id" }),
          { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } },
        )
      }

      // Find the oldest active, unexpired credit
      const { data: credit, error: findError } = await supabase
        .from("seedling_credits")
        .select("id, credit_amount")
        .eq("user_id", userId)
        .eq("status", "active")
        .gt("expires_at", new Date().toISOString())
        .order("created_at", { ascending: true })
        .limit(1)
        .maybeSingle()

      if (findError) {
        return new Response(
          JSON.stringify({ error: "Error finding credit", details: findError.message }),
          { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
        )
      }

      if (!credit) {
        return new Response(
          JSON.stringify({ error: "No active credit available" }),
          { status: 404, headers: { ...corsHeaders, "Content-Type": "application/json" } },
        )
      }

      // Mark the credit as redeemed
      const { data: updated, error: updateError } = await supabase
        .from("seedling_credits")
        .update({
          status: "redeemed",
          redeemed_at: new Date().toISOString(),
          redeemed_amount: credit.credit_amount,
          redemption_order_id: order_id,
          updated_at: new Date().toISOString(),
        })
        .eq("id", credit.id)
        .select("id, credit_amount, redeemed_at, redemption_order_id")
        .single()

      if (updateError) {
        return new Response(
          JSON.stringify({ error: "Error redeeming credit", details: updateError.message }),
          { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
        )
      }

      return new Response(
        JSON.stringify({
          redeemed: true,
          credit_id: updated.id,
          redeemed_amount: updated.credit_amount,
          redeemed_at: updated.redeemed_at,
          redemption_order_id: updated.redemption_order_id,
        }),
        { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      )
    }

    return new Response(
      JSON.stringify({ error: "Invalid action. Must be 'check' or 'redeem'" }),
      { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    )
  } catch (err) {
    return new Response(
      JSON.stringify({ error: "Internal server error", details: String(err) }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    )
  }
})
