export default function handler(req, res) {

  if(req.method !== "POST"){
    return res.status(405).end();
  }

  const { email, password } = req.body;

  // 初始主权账户（你后面可以随时扩展为数据库）
  if(email === "admin@yishen.ai" && password === "yishen2026"){
    res.status(200).json({
      ok:true,
      role:"sovereign",
      redirect:"/sovereign/dashboard.html"
    });
  } else {
    res.status(401).json({
      ok:false,
      msg:"Invalid credentials"
    });
  }
}
