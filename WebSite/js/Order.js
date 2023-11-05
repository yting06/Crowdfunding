
// 隱藏 'hide items' buttons
$(".btnHideItems").hide();

// 隱藏 order items tr
$("tr[data-is-detail=true]").hide();

// 註冊 .btnShowItems, .btnHideItems 的 click 事件
$(".btnShowItems").click(function () {
    let self = $(this);
    let orderId = self.data("order-id");

    $("tr[data-order-id=" + orderId + "]").show();
    $(".btnHideItems[data-order-id=" + orderId + "]").show();
    self.hide();
});

$(".btnHideItems").click(function () {
    let self = $(this);
    let orderId = self.data("order-id");

    $("tr[data-order-id=" + orderId + "]").hide();
    $(".btnShowItems[data-order-id=" + orderId + "]").show();
    self.hide();
});