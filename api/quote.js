import fs from "fs";
import path from "path";

function pickTier(tiers, qty){
  for (const t of tiers){
    if(qty >= t.min && qty <= t.max) return t;
  }
  return tiers[tiers.length - 1];
}

export default async function handler(req, res){
  try{
    const { sku, qty, country, state } = req.query;
    const q = Number(qty || 0);
    if(!sku || !q || q <= 0){
      return res.status(400).json({
        ok:false,
        error:"Missing sku or qty",
        example:"/api/quote?sku=YG-MESH-01&qty=300&country=US&state=CA"
      });
    }

    const file = path.join(process.cwd(), "data", "autoquote.json");
    const db = JSON.parse(fs.readFileSync(file, "utf8"));
    const p = db.products.find(x => x.sku === sku);

    if(!p){
      return res.status(404).json({ ok:false, error:"SKU not found", sku });
    }

    const tier = pickTier(p.price_tiers, q);
    const unit = tier.unit;

    // 你可在这里加入国家/州的运费、清关、税费、DDP 等规则
    // 先给一个可落地的“成交型输出”
    const leadTimeDays = (country === "US" || country === "CA") ? "20-35" : "25-45";
    const moq = p.moq || db.default_moq;

    const subtotal = Number((unit * q).toFixed(2));

    return res.status(200).json({
      ok:true,
      brand:"Yishen Global",
      sku,
      product_name:p.name,
      qty:q,
      moq,
      currency: db.currency,
      unit_price: unit,
      subtotal,
      lead_time_days: leadTimeDays,
      incoterms_suggested: (country === "US" || country === "CA") ? ["DDP", "DAP", "FOB"] : ["FOB", "CIF", "DAP"],
      next_step: "Reply with: CONFIRM + destination city/zip, we return a proforma + packing suggestion."
    });
  }catch(e){
    return res.status(500).json({ ok:false, error:e?.message || "server_error" });
  }
}
