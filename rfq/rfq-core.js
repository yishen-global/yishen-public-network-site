document.getElementById('rfqForm').addEventListener('submit',function(e){
 e.preventDefault();
 var d=new FormData(this);
 window.open('https://wa.me/='+encodeURIComponent('RFQ:'+d.get('product')+' '+d.get('message')));
});
