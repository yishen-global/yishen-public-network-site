<!doctype html>
<html>
<body>
<h1>Instant Auto Quote</h1>
<form>
Product <input name='product'><br>
Qty <input name='qty'><br>
<button>Quote</button>
</form>

<?php
if(isset(\['product'])){
\ = json_decode(file_get_contents('map.json'), true);
\ = strtolower(\['product']);
if(isset(\[\])){
\ = \[\];
echo "<p>MOQ: {\['MOQ']}</p>";
echo "<p>FOB: {\['FOB']} USD</p>";
echo "<p>Lead Time: {\['LEAD']}</p>";
}
}
?>
</body>
</html>
