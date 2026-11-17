<?php
session_start();
if (!isset($_SESSION['loginok']) || $_SESSION['loginok'] != 'ok') {
    header('location:erro.html');
    exit;
}
?>
