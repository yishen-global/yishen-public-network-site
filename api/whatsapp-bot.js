export default function handler(req, res) {
  const body = req.body || {};
  const text = (body.text || "").toLowerCase();

  let reply = "🔥 YiShen Global RFQ Center\n\nReply number:\n1 Office Chair\n2 Gaming Chair\n3 Sofa\n4 Industrial Chain";

  if (text.includes("1")) {
    reply = "🪑 Office Chair RFQ\nMOQ 50 pcs\nDelivery 15–20 days\nSend qty + city.";
  }
  if (text.includes("2")) {
    reply = "🎮 Gaming Chair RFQ\nMOQ 100 pcs\nOEM/ODM OK\nSend qty + platform.";
  }
  if (text.includes("3")) {
    reply = "🛋 Sofa RFQ\nMOQ 20 sets\nHotel/Commercial OK\nSend project type + qty.";
  }
  if (text.includes("4")) {
    reply = "⛓ Industrial Chain RFQ\nMOQ 1 ton\nEN818 / G80\nSend application + qty.";
  }

  res.status(200).json({ reply });
}
