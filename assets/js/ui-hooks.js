/* YISHEN_UI_HOOKS v1 */
(async function () {
  async function inject(id, url) {
    const el = document.getElementById(id);
    if (!el) return;
    const res = await fetch(url, { cache: "no-cache" });
    if (!res.ok) return;
    el.innerHTML = await res.text();
  }
  await inject("yishen_nav", "/components/navbar.html");
  await inject("yishen_footer", "/components/footer.html");
})();
