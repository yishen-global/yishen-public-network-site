export default function handler(req, res) {
  const c = (req.headers['x-vercel-ip-country'] || 'WORLD').toLowerCase();
  const map = {
    us:'us',ca:'ca',mx:'mx',br:'br',ar:'ar',cl:'cl',co:'co',pe:'pe',
    de:'de',fr:'fr',uk:'uk',it:'it',es:'es',nl:'nl',pl:'pl',cz:'cz',
    sa:'sa',ae:'ae',qa:'qa',kw:'kw',om:'om',eg:'eg',ma:'ma',za:'za',
    in:'in',pk:'pk',bd:'bd',jp:'jp',kr:'kr',tw:'tw',hk:'hk',sg:'sg',
    au:'au',nz:'nz',ru:'ru',ua:'ua',by:'by',kz:'kz',uz:'uz',tm:'tm',
    tr:'tr',il:'il',ir:'ir',iq:'iq',jo:'jo',lb:'lb',sy:'sy',ye:'ye'
  };
  const dest = map[c] || 'world';
  res.writeHead(302,{Location:`/${dest}/`});
  res.end();
}
