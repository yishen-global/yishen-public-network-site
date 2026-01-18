export default async function handler(req, res){
  if(req.method !== "POST"){
    return res.status(405).json({ ok:false, error:"method_not_allowed" });
  }

  try{
    const { to, text } = req.body || {};
    if(!to || !text){
      return res.status(400).json({ ok:false, error:"missing_to_or_text" });
    }

    const token = process.env.WHATSAPP_TOKEN;
    const phoneId = process.env.WHATSAPP_PHONE_NUMBER_ID;

    if(!token || !phoneId){
      return res.status(500).json({ ok:false, error:"missing_env_WHATSAPP_TOKEN_or_PHONE_NUMBER_ID" });
    }

    const url = `https://graph.facebook.com/v19.0/${phoneId}/messages`;
    const payload = {
      messaging_product: "whatsapp",
      to,
      type: "text",
      text: { body: text }
    };

    const r = await fetch(url, {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${token}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify(payload)
    });

    const data = await r.json();
    return res.status(r.status).json({ ok: r.ok, data });

  }catch(e){
    return res.status(500).json({ ok:false, error:e?.message || "send_error" });
  }
}
