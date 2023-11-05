[]Share/_Layout
9/18
	Modify 導覽頁連結(團隊管理、專案列表、商品列表)


[working on] 實作 專案列表
9/15
	add Controllers/ProjectsController
	add Models/ViewModels/ProjectVm
	add Views/Projects/Index
	add Views/Projects/Create(類別下拉式清單)
9/17
	Modify Controllers/ProjectsController
	Modify Views/Projects/Index
	Modify Views/Projects/Create
	add Views/Projects/Edit(類別下拉式清單)
	add Views/Projects/Delete
9/18
	Modify Controllers/ProjectsController
		-add Controllers/ProductsController/ActionResult(存取DB)(從Table Project取回資料，並對應到ProjectVm的欄位)
	Modify Views/Projects/Index
		-add Views/Projects/Index button(按鈕:新增商品)
9/19
	Modify Models/ViewModels/ProjectVm
	Modify Views/Projects/Index
	Modify Views/Projects/Create
	Modify Views/Projects/Edit
9/20
	Modify Models/EFModels/Project
	Modify Models/ViewModels/ProjectVm
	Modify Controllers/ProjectsController/Action/Index
	Modify Views/Projects/Index(取Category type內容)
9/21
	Delete  Views/Projects/Create(刪除頁籤Tabs)
	Modify Controllers/ProjectsController/Action/Create

9/22
	Modify Controllers/ProjectsController/Action/Create
	Modify Models/ViewModels/ProjectVm
	Modify Views/Projects/Create
	Modify Views/Projects/Edit
9/23
	Modify Controllers/ProjectsController/Action/Create
	Modify Models/ViewModels/ProjectVm
	Modify Views/Projects/Create(新增專案功能完成)(Company待處理)
9/25
	Modify Controllers/ProjectsController/Action/Create、Index
		Create下拉式選單-空白改為請選擇
	Modify Views/Projects/Index(查詢功能完成)
	Modify Views/Projects/Delete(刪除功能專案完成)
	Modify Models/ViewModels/ProjectVm
		add string CategoryName
	Modify Controllers/ProjectsController/Action/Edit
	Modify Views/Projects/Edit(編輯專案功能專案完成)
	add Controllers/ProjectsController/Action/CreateProjectUpdate、EditProjectUpdate
		add  Views/Projects/CreateProjectUpdate、EditProjectUpdate

	修改圖片上傳處


[working on]實作 商品列表
9/17
	add Controllers/ProductsController
	add Models/ViewModels/ProductVm
	add Views/Products/Index
	add Views/Products/Create
	add Views/Products/Edit
	add Views/Products/Delete
9/18
	Modify Controllers/ProductsController (存取DB)
		-add Controllers/ProductsController/ActionResult(存取DB)(從Table Products取回資料，並對應到ProductsVm的欄位)
	add 
9/19
	
	Modify Views/Products/Index
	Modify Views/Products/Create
	Modify Views/Products/Edit
9/22
	Modify Controllers/ProductsController/Action/Create
	Modify Models/ViewModels/ProductVm
	Modify Views/Products/Index
	Modify Views/Products/Create
	Modify Views/Products/Edit
	Modify Views/Products/Delete
9/23
	Modify Controllers/ProductsController/Action/Create
	Modify Models/ViewModels/ProductVm
	Modify Views/Products/Create(新增商品功能完成)
	Modify Views/Products/Delete(刪除商品完成)
	編輯功能壞掉大處理
9/25
	Modify Controllers/ProductsController/Action/Create、Index、Edit
		Create下拉式選單-空白改為請選擇
	Modify Views/Products/Index(查詢功能完成)
		add @if (@item.Project.Enabled == false) (只有不啟用才能編輯畫面)
	Modify Views/Products/Edit(編輯商品功能完成)
		add @Html HiddenFor
	Modify Models/ViewModels/ProductVm
		add Project Project
		
	

[working on]實作 註冊團隊功能
9/18
	add Models/ViewModels/CompanyVm

9/19
	add Controllers/CompaniesController
	add Models/ViewModels/RegisterVm
	add Models/ViewModels/RegisterExts
	add Models/Infra/HashUtility
9/25
	Modify Controllers/CompaniesController