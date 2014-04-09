<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@include file="../global.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>用户管理</title>
<c:forEach var="role" items="${user.roles }">
	<c:if test="${roleLevel==null||role.roleLevel<roleLevel }">
		<c:set var="roleLevel" value="${role.roleLevel }"></c:set>

	</c:if>

</c:forEach>

<script type="text/javascript">
	var level = '${roleLevel }';
	//alert(level);
	Ext.require([ 'Ext.grid.*', 'Ext.toolbar.Paging', 'Ext.data.*',
			'Ext.form.*' ]);
	Ext.onReady(function() {
		
	
		Ext.QuickTips.init();
		function add() {
			//alert(level);
			var win = new Ext.Window({
				title : "添加用户",
				width : 347,
				height : 250,
				iconCls : "center_icon",
				buttonAlign : 'center',
				items : [ {
					xtype : "form",
					id : "form1",
					height : "250",
					borderStyle : "padding-top:3px",
					frame : true,
					defaultType : "textfield",
					labelAlign : "right",
					labelWidth : 57,
					defaults : {
						allowBlank : false,
						width : 200,
						msgTarget : 'side'
					},
					items : [ {
						fieldLabel : "用户名",
						name : "userName",
						blankText : "请输入用户名，用于登录"
					}, {
						fieldLabel : "姓名",
						name : "userFullName",
						blankText : "请输入用户姓名"
					}, {
						fieldLabel : "密码",
						name : "password",
						blankText : "请输入用户密码",
						value : '123456'
					} ]
				} ],
				buttons : [ {
					xtype : "button",
					text : "确定",
					handler : function() {
						if (!Ext.getCmp("form1").getForm().isValid()) {

							return false;
						}
						Ext.getCmp("form1").getForm().submit({
							clientValidation : true,
							waitMsg : '请稍候',
							waitTitle : '正在添加',
							url : '${ctx}/system/user/addUser',
							success : function(form, action) {
								Ext.MessageBox.show({
									width : 150,
									title : "添加成功",
									buttons : Ext.MessageBox.OK,
									msg : action.result.msg
								});
								win.close();
								Ext.getCmp("gridPanel").store.reload();
							},
							failure : function(form, action) {
								Ext.MessageBox.show({
									width : 150,
									title : "添加失败",
									buttons : Ext.MessageBox.OK,
									msg : action.result.msg
								});
								// console.log(win.ownerCt);

							}

						})

					}
				}, {
					xtype : "button",
					text : "取消",
					handler : function() {
						win.close();
					}
				} ]
			});
			win.show();
		}

		function edit() {

			var selRecords = Ext.getCmp("gridPanel").getSelectionModel()
					.getSelection();

			var id, userName, userFullName, password, loginNum;
			if (selRecords.length >= 1) {

				id = selRecords[0].get("id");
				userName = selRecords[0].get("userName");
				userFullName = selRecords[0].get("userFullName");
				password = selRecords[0].get("password");
				loginNum = selRecords[0].get("loginNum");

			} else {
				Ext.MessageBox.alert("提示消息", "您未选中行");
				return false;
			}
			var win = new Ext.Window({
				title : "修改记录窗口",
				width : 347,
				height : 200,
				items : [ {
					xtype : "form",
					id : "form1",
					height : "200",
					borderStyle : "padding-top:3px",
					frame : true,
					defaultType : "textfield",
					labelAlign : "right",
					labelWidth : 57,
					defaults : {
						allowBlank : false,
						width : 200
					},
					items : [ {
						xtype : 'hiddenfield',
						name : 'id',
						value : id
					}, {
						fieldLabel : "用户名",
						name : "userName",
						blankText : "请输入用户名,用于登录",
						value : userName
					}, {
						fieldLabel : "姓名",
						name : "userFullName",
						blankText : "请输入姓名",
						value : userFullName
					}, {
						fieldLabel : "密码",
						name : "password",
						blankText : "请输入密码",
						value : password
					}, {
						fieldLabel : "登录次数",
						name : "loginNum",
						blankText : "请输入登陆次数",
						xtype : "numberfield",
						minValue : 0,
						value : loginNum
					} ]
				} ],//vtype的值:alpha,alphanum,email,url
				buttons : [ {
					xtype : "button",
					text : "确定",
					handler : function() {
						if (!Ext.getCmp("form1").getForm().isValid()) {
							alert("您输入的信息有误,请重新输入...");
							return false;
						}
						Ext.getCmp("form1").getForm().submit({
							clientValidation : true,
							waitMsg : '请稍候',
							waitTitle : '正在提交',
							url : '${ctx}/system/user/updateUser',
							success : function(form, action) {
								Ext.MessageBox.show({
									width : 150,
									title : "更新成功",
									buttons : Ext.MessageBox.OK,
									msg : action.result.msg
								});
								win.close();
								Ext.getCmp("gridPanel").store.reload();
							},
							failure : function(form, action) {
								Ext.MessageBox.show({
									width : 150,
									title : "更新失败",
									buttons : Ext.MessageBox.OK,
									msg : action.result.msg
								});
								// console.log(win.ownerCt);

							}

						})
					}
				}, {
					xtype : "button",
					text : "取消",
					handler : function() {
						win.close();
					}
				} ]
			}).show();

		}

		function del() {
			var selRecords = Ext.getCmp("gridPanel").getSelectionModel()
					.getSelection();
			var len = selRecords.length;
			var ids = "";
			if (len == 0) {
				Ext.MessageBox.alert("提示消息", "您未选中行");
				return false;
			}
			Ext.Msg.confirm("提示", "确定要删除吗?", function(btn) {
				if (btn == "yes") {
					for (var i = 0; i < len; i++) {
						if (i == len - 1) {
							ids += selRecords[i].get("id");
						} else {
							ids += selRecords[i].get("id") + ",";
						}
					}
					Ext.Ajax.request({
						url : "${ctx}/system/user/betchDelUser/" + ids,
						/* params: {
						    "ids": ids
						}, */
						success : function(reponse, option) {
							json = eval("(" + reponse.responseText + ")");
							Ext.MessageBox.show({
								width : 150,
								title : "操作结果",
								buttons : Ext.MessageBox.OK,
								msg : json.msg
							});

							Ext.getCmp("gridPanel").store.reload();
						},
						failure : function() {
							alert("删除失败");
						}

					});
				}
			})
		}
		function userSet() {
			var selRecords = Ext.getCmp("gridPanel").getSelectionModel()
					.getSelection();

			var id, userName, userFullName, password, loginNum;
			if (selRecords.length >= 1) {

				id = selRecords[0].get("id");
				userName = selRecords[0].get("userName");
				userFullName = selRecords[0].get("userFullName");
				password = selRecords[0].get("password");
				loginNum = selRecords[0].get("loginNum");

			} else {
				Ext.MessageBox.alert("提示消息", "您未选中行");
				return false;
			}
			var win = new Ext.Window({
				title : "配置用户角色窗口",
				width : 347,
				height : 500,
				items : [ {
					xtype : "form",
					id : "form1",
					height : "200",
					borderStyle : "padding-top:3px",
					frame : true,
					defaultType : "textfield",
					labelAlign : "right",
					labelWidth : 57,
					defaults : {
						allowBlank : false,
						width : 200
					},
					items : [  ]
				} ],//vtype的值:alpha,alphanum,email,url
				buttons : [ {
					xtype : "button",
					text : "确定",
					handler : function() {
						if (!Ext.getCmp("form1").getForm().isValid()) {
							alert("您输入的信息有误,请重新输入...");
							return false;
						}
						//console.log(Ext.getCmp("role_checkboxgroup").getValue());
						//var rids=Ext.getCmp("role_checkboxgroup").getValue().roleName;
					
						Ext.getCmp("form1").getForm().submit({
							clientValidation : true,
							waitMsg : '请稍候',
							waitTitle : '正在提交',
							url : '${ctx}/system/user/updateUserRoles/'+id,
						//	params:{rids:rids},
							success : function(form, action) {
								Ext.MessageBox.show({
									width : 150,
									title : "设置成功",
									buttons : Ext.MessageBox.OK,
									msg : action.result.msg
								});
								win.close();
								Ext.getCmp("gridPanel").store.reload();
							},
							failure : function(form, action) {
								Ext.MessageBox.show({
									width : 150,
									title : "设置失败",
									buttons : Ext.MessageBox.OK,
									msg : action.result.msg
								});
								// console.log(win.ownerCt);

							}

						})
					}
				}, {
					xtype : "button",
					text : "取消",
					handler : function() {
						win.close();
					}
				} ]
			}).show();
			Ext.Ajax.request({
				url:'${ctx}/system/role/getAllRoles',
				callback:function(options,success,response){
					if(success==true){
						var roles=eval("("+response.responseText+")");
						//拼接checkbox子项目
			        	var checkboxitems="";
						//console.log(roles);
						for(var i = 0;i<roles.length;i++){
							if(checkboxitems!="")
			        			checkboxitems+=",";
			        		else
			        			checkboxitems+="[";
			                var groupid = roles[i].id;
			        		var checkboxSingleItem = "{boxLabel:'"+roles[i].roleName+"',name:'rids',id:'"+roles[i].id+"',inputValue:'"+roles[i].id+"'";
			        		/* var usergroup=obj.usergroups;
			    			for(var j=0;j<usergroup.length;j++){
			    				 if(usergroup[j].groupid == groupid){
			 	                	checkboxSingleItem += ",checked:'true'";
			 	                }
			    			} */
			    			checkboxSingleItem+="}";
			    			
			    			checkboxitems+=checkboxSingleItem;
							
						}
						checkboxitems+="]";
							
						//获取用户的角色属性
						Ext.Ajax.request({
							url:'${ctx}/system/user/getUserRoles/'+id,
							callback:function(options,success,response){
								if(success==true){
									var roles=eval("("+response.responseText+")");
									var items=eval(checkboxitems);
									//console.log(roles);
									//console.log(items);
								    for(var j=0;j<roles.length;j++){
								    	var urid=roles[j].id;
								    	for(var m=0;m<items.length;m++){
								    		var irid=items[m].id;
								    		if(urid==irid){
								    			items[m].checked=true;
								    		}
								    	}
								    }
								    var itemsGroup = new Ext.form.CheckboxGroup({
						    			fieldLabel: '选择权限',
						    			name:'rids',
						    			width:380,
						    			id:'role_checkboxgroup',
						    		    columns: 1,
						        	    width:360,
						        	    columns:1,
						        	    items:items
						        	});
								    Ext.getCmp("form1").add(itemsGroup);
									
										
									}else{
										Ext.MessageBox.show({
											width : 150,
											title : "出错了",
											buttons : Ext.MessageBox.OK,
											msg : '加载用户组出错了，请稍后重试...'
										});
									}
							}
						});
						
						
						
						
					}else{
						Ext.MessageBox.show({
							width : 150,
							title : "出错了",
							buttons : Ext.MessageBox.OK,
							msg : '加载用户组出错了，请稍后重试...'
						});
					}
				}
			});
		}
		//var app={};//全局变量  

		Ext.define("User", {
			extend : "Ext.data.Model",
			fields : [ {
				name : "id"
			}, {
				name : "loginNum"
			}, {
				name : "userName"
			}, {
				name : "password"
			}, {
				name : "userFullName"
			}, {
				name : "createUser"
			}, {
				name : "state"
			}, {
				name : "roles"
			} ]
		});
		var itemsPerPage = 10; //分页大小
		var store = Ext.create("Ext.data.JsonStore", {
			// baseParams: {},
			autoLoad : {
				start : 0,
				limit : itemsPerPage,
				page : 1
			},
			pageSize : itemsPerPage, // 分页大小
			model : "User",
			proxy : {
				type : "ajax",
				url : "${ctx}/system/user/getUsers",
				actionMethods : {
					read : 'POST'
				},
				extraParams : {},
				reader : {
					type : "json",
					root : "items",
					totalProperty : 'count'

				}
			}
		});
		var rn = Ext.create('Ext.grid.RowNumberer', {
			header : "编号",
			width : 30,
			css : 'color:blue;'
		});
		var roleCheckPanel = Ext.create("Ext.form.Panel", {
			bodyPadding : 5,
			layout : 'form',
			frame : true,
			border : true,
			buttonAlign : 'center',
			width : 970,
			defaults : {
				frame : true,
			},
			items : [ {
				layout : 'column',//第一行
				defaults : {
					frame : true
				},
				items : [ {
					columnWidth : '.5',//第一列
					layout : 'form',
					defaults : {

						labelWidth : 60,
						frame : true,
						border : false,
						labelSeparator : ':',
						labelAlign : 'right',
						msgTarget : 'side'
					},
					items : [ {
						xtype : 'textfield',
						fieldLabel : '用户名',
						name : 'userName',
						id : 'userName'
					} ]
				}, {
					columnWidth : '.5',
					layout : 'form',
					defaults : {

						labelWidth : 60,
						frame : true,
						border : false,
						labelSeparator : ':',
						labelAlign : 'right',
						msgTarget : 'side'
					},
					items : [ {
						xtype : 'textfield',
						fieldLabel : '姓名',
						name : 'userFullName',
						id : 'userFullName'
					} ]
				} ]
			} ],
			buttons : [ {
				text : '重置',
				handler : function() {
					this.up('form').getForm().reset();
				}
			}, {
				text : '查询',
				formBind : true, //only enabled once the form is valid
				disabled : true,
				handler : function() {
					var form = this.up('form').getForm()

					if (form.isValid()) {
						var formValues = form.getValues();
						var params = dataGrid.store.getProxy().extraParams;
						Ext.apply(params, formValues);
						dataGrid.store.getProxy().extraParams = params;
						store.currentPage = 1
						dataGrid.store.load({
							params : {
								start : 0,
								limit : 10,
								page : 1
							}
						});
					}
				}
			} ]

		});
		var sm = Ext.create('Ext.selection.CheckboxModel', {
			checkOnly : true
		});
		var pageBar = Ext.create('Ext.PagingToolbar', {
			id : 'pageBar',
			//	dock: 'bottom', //分页 位置  
			afterPageText : '共{0}页',
			beforePageText : '当前页',
			lastText : "尾页",
			nextText : "下一页",
			prevText : "上一页",
			firstText : "首页",
			refreshText : "刷新页面",
			store : store,
			displayInfo : true,
			displayMsg : '显示{0}-{1}条，共{2}条记录',
			emptyMsg : "没有数据",
			items : [ {
				text : "第一行",
				handler : function() {
					var rsm = dataGrid.getSelectionModel(); //得到选择模型
					rsm.select(0);
				}
			}, {
				text : "上一行",
				handler : function() {
					var rsm = dataGrid.getSelectionModel(); //得到选择模型
					if (rsm.isSelected(0)) {
						Ext.MessageBox.alert("警告", "已到达第一行");
					} else {
						rsm.selectPrevious();
					}
				}
			}, {
				text : "下一行",
				handler : function() {
					var length = store.data.length - 1
					var rsm = dataGrid.getSelectionModel(); //得到选择模型
					if (rsm.isSelected(length)) {
						Ext.MessageBox.alert("警告", "已到达最后一行");
					} else {
						rsm.selectNext();
					}
				}
			}, {
				text : "最后一行",
				handler : function() {
					var length = store.data.length - 1
					var rsm = dataGrid.getSelectionModel(); //得到选择模型
					rsm.select(length);
				}
			}, {
				text : "全选",
				handler : function() {
					var rsm = dataGrid.getSelectionModel(); //得到选择模型
					rsm.selectAll();
				}
			}, {
				text : "全不选",
				handler : function() {
					var length = store.data.length - 1
					var rsm = dataGrid.getSelectionModel(); //得到选择模型
					rsm.deselectRange(0, length);
				}
			}, {
				text : "反选",
				handler : function() {
					var rsm = dataGrid.getSelectionModel(); //得到选择模型
					var length = store.data.length - 1;
					for (var i = length; i >= 0; i--) {
						if (rsm.isSelected(i)) {

							rsm.deselect(i, true);
						} else {

							rsm.select(i, true); //必须保留原来的,否则效果无法显示
						}
					}
				}
			} ]
		});
		var dataGrid = Ext.create('Ext.grid.Panel', {
			id : 'gridPanel',
			frame : true,
			store : store,
			viewConfig: {
		        getRowClass: function(record, rowIndex, rowParams, store){
		        	if(rowIndex%2!=0){
		        		return 'rowClass';
		        	}
		        	 
		        }
		    },
			//viewConfig: {forceFit:true},
			loadMask : true,
			selModel : sm,
			columns : [ rn, {
				flex : 3,
				text : '用户名',
				dataIndex : 'userName'
			}, {
				flex : 3,
				text : '姓名',
				dataIndex : 'userFullName'
			}, {
				flex : 3,
				text : '登陆次数',
				dataIndex : 'loginNum'
			} ],

			tbar : [ {
				text : '添加',
				tooltip : '添加用户',
				iconCls : 'add',
				handler : add

			}, '-', {
				text : '修改',
				tooltip : '修改用户',
				iconCls : 'edit',
				handler : edit
			}, '-', {
				text : '删除',
				tooltip : '删除用户',
				iconCls : 'remove',
				handler : del
			}, '-', {
				text : '设置',
				tooltip : '设置角色',
				iconCls : 'userSet',
				handler : userSet
			} ],
			bbar : pageBar,

			buttonAlign : "center",

			buttons : []
		});
		Ext.create('Ext.panel.Panel', {
			frame : true,
			bodyPadding : 10, // Don't want content to crunch against the borders
			width : 1000,
			items : [ roleCheckPanel, dataGrid ],
			renderTo : Ext.getBody()
		});

	});

	/* Ext.require([
	 "Ext.data.*",
	 "Ext.form.*",
	 "Ext.grid.Panel",
	 "Ext.layout.container.Column"
	 ]);
	 Ext.onReady(function() {
	
	 Ext.QuickTips.init();
	 var bd = Ext.getBody();
	
	 // store data(static)
	 var storedata = [
	 ['大唐牛肉无限公司', 1100.00, -0.01,  -0.013,  '2012-02-27'],
	 ['大唐武器无限公司', 1200.00, 0.02,  0.033,  '2012-02-28'],
	 ['大唐资源无限公司', 1300.00, -0.03,  -0.043,  '2012-02-29'],
	 ['大唐人才无限公司', 1400.00, 0.04,  0.053,  '2012-03-27'],
	 ['大唐环境维护无限公司', 1500.00, 0.05,  0.023,  '2012-03-26'],
	 ['大唐矿产无限公司', 1600.00, -0.06,  -0.063,  '2012-03-25'],
	 ['大唐精矿无限公司', 1700.00, 0.07,  0.073,  '2012-03-24'],
	 ['大唐铁矿无限公司', 1800.00, 0.08,  0.083,  '2012-03-23'],
	 ['大唐铝土矿无限公司', 1900.00, 0.09,  0.093,  '2012-03-22'],
	 ['大唐煤资源无限公司', 2000.00, -0.022,  -0.031,  '2013-02-21'],
	 ['大唐天然气无限公司', 1110.00, 0.023,  0.032,  '2012-03-20'],
	 ['大唐太阳能无限公司', 1220.00, -0.024,  -0.033,  '2012-03-19'],
	 ['大唐激光武器无限公司', 1330.00, 0.025,  0.034,  '2012-03-18'],
	 ['大唐汽车无限公司', 1450.00, 0.026,  0.053,  '2012-03-17'],
	 ['大唐卡车配件无限公司', 1660.00, 0.027,  0.036,  '2012-03-16']
	 ];
	
	 // store
	 var dstore = Ext.create('Ext.data.ArrayStore', {
	 fields: [{
	 name: "company"
	 }, {
	 name: "price", type: "float"
	 }, {
	 name: "change", type: "float"
	 }, {
	 name: "pctChange", type: "float"
	 }, {
	 name: "lastChange", type: "date", dateFormat: "Y-m-d"
	 }, 
	 // Rating field dependent upon performance 0=best(A), 2=worst(C);
	 {
	 name: "rating", 
	 type: "int", 
	 convert: function(value, record) {
	 var pct = record.get('pctChange');
	 if(pct<0) return 2;
	 if(pct<1) return 1;
	 return 0;
	 }
	 }],
	 data: storedata
	 });
	
	 // 自定义行内容渲染：
	 function change(val) {
	 if(val > 0) {
	 return '<span style="color: green;">'+ val +'</span>';
	 } else if(val < 0) {
	 return '<span style="color: red;">'+ val +'</span>';
	 }
	
	 return val;
	 }
	 function pctChange(v) {
	 if(v!=0) {
	 return Ext.String.format('<span style="color: {0};">{1}%</span>', v>0?"green":"red", v);
	 } else {
	 return v;
	 }
	 }
	 function rating(v) {
	 if(v==0) return "A";
	 if(v==1) return "B";
	 if(v==2) return "C";
	 }
	
	 bd.createChild({tag: 'h2', html: 'Using a Grid with a Form'});
	
	 // form-grid
	 var gridForm = Ext.create('Ext.form.Panel', {
	 id: "compony-form",
	 renderTo: bd,
	
	 title: "TheCompanyData",
	 frame: true,
	 width: 750,
	 bodyPadding: 5,
	 layout: 'column', // 列布局；
	
	 fieldDefaults: {
	 labelAlign: "left",
	 msgTarget: "side"
	 },
	
	 items: [{    // grid
	 columnWidth: 0.60,
	 xtype: "gridpanel",
	 store: dstore,
	 title: "公司概况",
	
	 columns: [{
	 id: 'company',
	 text: "公司名称",
	 dataIndex: "company",
	 sortable: true,
	 flex: 1        // grid宽度减去固定列宽以后占一份；
	 }, {
	 text: "公司资产",
	 dataIndex: "price",
	 width: 70,
	 sortable: true
	 }, {
	 text: "资产增值量",
	 dataIndex: "change",
	 width: 75,
	 sortable: true,
	 renderer: change
	 }, {
	 text: "资产增值百分比",
	 dataIndex: "pctChange",
	 width: 90,
	 sortable: true,
	 renderer: pctChange
	 }, {
	 text: "更新时间",
	 dataIndex: "lastChange",
	 width: 85,
	 sortable: true,
	 align: "center",
	 renderer: Ext.util.Format.dateRenderer('Y-m-d')
	 }, {
	 text: "等级",
	 dataIndex: "rating",
	 width: 30,
	 sortable: true,
	 align: "center",
	 renderer: rating
	 }],
	 // 监听grid事件：
	 listeners: {
	 selectionchange: function(model, records) {
	 if(records[0]) {    // 加载进form表单中；
	 this.up('form').getForm().loadRecord(records[0]);
	 }
	 }
	 }
	 }, {    // form
	 columnWidth: 0.4,
	 margin: '0 0 0 10',
	 xtype: "fieldset",
	 title: '公司详细信息',
	 defaults: {
	 width: 240,
	 labelWidth: 90,
	 labelAlign: "right"
	 },
	 defaultType: "textfield",
	 items: [{
	 fieldLabel: "公司名称",
	 name: "company"
	 }, {
	 fieldLabel: "公司资产",
	 name: "price"
	 }, {
	 fieldLabel: "资产增值量",
	 name: "change"
	 }, {
	 fieldLabel: "资产增值百分比",
	 name: "pctChange"
	 }, {
	 fieldLabel: "更新时间",
	 name: "lastChange",
	 xtype: "datefield",
	 format: "Y-m-d"
	 }, {
	 fieldLabel: "等级",
	 xtype: "radiogroup",
	 columns: 3,
	 defaults: {
	 name: "rating"
	 },
	 items: [{
	 inputValue: "0",
	 boxLabel: "A"
	 }, {
	 inputValue: "1",
	 boxLabel: "B"
	 }, {
	 inputValue: "2",
	 boxLabel: "C"
	 }]
	 }]
	 }]
	 });
	
	 // 给grid默认选择第一行：
	 gridForm.child('gridpanel').getSelectionModel().select(0);
	 }); */
</script>
</head>
<body>
</body>
</html>