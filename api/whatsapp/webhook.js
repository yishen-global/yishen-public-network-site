export default async function handler(req, res){
  // Webhook verify (Meta)
  if(req.method === "GET"){
    const mode = req.query["hub.mode"];
    const token = req.query["hub.verify_token"];
    const challenge = req.query["hub.challenge"];
    if(mode === "subscribe" && token && token === process.env.WHATSAPP_VERIFY_TOKEN){
      return res.status(200).send(challenge);
    }
    return res.status(403).send("Verification failed");
  }

  if(req.method !== "POST"){
    return res.status(405).json({ ok:false, error:"method_not_allowed" });
  }

  try{
    const body = req.body;

    // 这里按 Cloud API 的常见结构取 message 文本（不同事件结构会有差异）
    const entry = body?.entry?.[0];
    const changes = entry?.changes?.[0];
    const value = changes?.value;
    const messages = value?.messages || [];
    const msg = messages?.[0];
    const from = msg?.from; // 用户手机号（wa_id）
    const text = msg?.text?.body || "";

    if(!from){
      return res.status(200).json({ ok:true, ignored:true });
    }

    const upper = String(text || "").trim().toUpperCase();

    // 简单路由：你可以替换成更强的“成交状态机”
    let reply = "";
    if(upper.startsWith("QUOTE")){
      // QUOTE SKU QTY COUNTRY STATE
      // 例：QUOTE YG-MESH-01 300 US CA
      const parts = upper.split(/\s+/);
      const sku = parts[1] || "YG-MESH-01";
      const qty = parts[2] || "100";
      const country = parts[3] || "US";
      const state = parts[4] || "";

      const url = `${process.env.PUBLIC_BASE_URL || ""}/api/quote?sku=${encodeURIComponent(sku)}&qty=${encodeURIComponent(qty)}&country=${encodeURIComponent(country)}&state=${encodeURIComponent(state)}`;
      reply = `✅ AutoQuote Ready\nSKU: ${sku}\nQTY: ${qty}\nCountry: ${country} ${state}\n\nOpen quote: ${url}\n\nReply: CONFIRM + City + Zip to lock proforma.`;
    }else if(upper.startsWith("CONFIRM")){
      reply = `🛡️ CONFIRM received.\nSend: (1) SKU + QTY (2) City/Zip (3) Incoterms (DDP/DAP/FOB)\nWe will issue Proforma + Packing plan + Lead-time commitment.`;
    }else if(upper.startsWith("RFQ")){
      reply = `📩 RFQ received.\nPlease paste your RFQ list (SKU/QTY/Target price/Delivery city).\nWe respond with: price tiers + lead time + compliance pack + next-step.`;
    }else{
      reply = `Hi — Yishen Global here.\nType:\n1) QUOTE SKU QTY COUNTRY STATE\n2) CONFIRM + City/Zip\n3) RFQ + your list\n\nExample: QUOTE YG-MESH-01 300 US CA`;
    }

    // 调用内部 send API（服务器端发送）
    const sendUrl = `${process.env.PUBLIC_BASE_URL || ""}/api/whatsapp/send`;
    await fetch(sendUrl, {
      method: "POST",
      headers: { "Content-Type":"application/json" },
      body: JSON.stringify({ to: from, text: reply })
    });

    return res.status(200).json({ ok:true });
  }catch(e){
    return res.status(200).json({ ok:true, warning: e?.message || "webhook_parse_warning" });
  }
}
