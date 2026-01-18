import nodemailer from 'nodemailer';

export default async function handler(req, res) {
  try {
    if (req.method !== 'POST') return res.status(405).json({ ok:false, error:'Method not allowed' });

    const body = typeof req.body === 'string' ? JSON.parse(req.body) : (req.body || {});
    const now = new Date().toISOString();

    const EMAIL_TO = process.env.EMAIL_TO || 'rfq@yishen.ai';

    const subject = [RFQ]  |  | .trim();
    const text = [
      TIME: ,
      PAGE: ,
      SOURCE: ,
      COMPANY: ,
      COUNTRY: ,
      NAME: ,
      EMAIL: ,
      WHATSAPP: ,
      PRODUCT: ,
      REQUIREMENTS:,
      ${body.requirements || ''}
    ].join('\\n');

    // SMTP (optional but recommended)
    const host = process.env.SMTP_HOST;
    const port = parseInt(process.env.SMTP_PORT || '587', 10);
    const user = process.env.SMTP_USER;
    const pass = process.env.SMTP_PASS;
    const from = process.env.SMTP_FROM || user;

    if (host && user && pass && from) {
      const transporter = nodemailer.createTransport({
        host, port,
        secure: port === 465,
        auth: { user, pass }
      });

      await transporter.sendMail({
        from,
        to: EMAIL_TO,
        subject,
        text
      });
    }

    // Return ok (frontend will jump to WhatsApp)
    return res.status(200).json({ ok:true });
  } catch (e) {
    return res.status(200).json({ ok:false, error: String(e?.message || e) });
  }
}