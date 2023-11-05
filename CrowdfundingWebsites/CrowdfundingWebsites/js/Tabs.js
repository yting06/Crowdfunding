$(document).ready(function() {
        //通過按鈕的點擊事件來選擇標籤動作
    $('#project-tab').on('click', function() {
        //顯示項目標籤頁並隱藏團隊標籤頁
        $('#project').addClass('show active');
        $('#team').removeClass('show active');

        // 更新按鈕的選中狀態
        $('#project-tab').addClass('active');
        $('#team-tab').removeClass('active');
    });

    $('#team-tab').on('click', function() {
        // 顯示團隊標籤頁並隱藏項目標籤頁
        $('#team').addClass('show active');
        $('#project').removeClass('show active');

        // 更新按鈕的選中狀態
        $('#team-tab').addClass('active');
        $('#project-tab').removeClass('active');
    });
});
