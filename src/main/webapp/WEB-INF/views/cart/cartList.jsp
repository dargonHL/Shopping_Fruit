<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../commons/nav.jsp"%>

    <div class="content-wrapper">
        <!-- Main content -->
        <section class="content">
            <div class="menu-button">
            <a type="button" class="btn btn-default" onclick="showChoose()">目录选择</a>
            <div class="box-body" style="display: none;" id="chooseType">
                <form action="<%=request.getContextPath()%>/fruit/searchByCategory" method="post">
                    <select name="typeList" id="typeList">
                        <option value="">请选择</option>
                    </select>
                    <input type="submit" class="btn btn-default" value="查询">
                </form>
            </div>
            <form action="<%=request.getContextPath()%>/fruit/checkFruit" method="post">
                <input type="text" placeholder="请填写水果名" name="fruitName">
                <input type="submit" class="btn btn-default" value="查询水果">
            </form>
            </div>

            <div class="box box-info">
                <div class="box-body" style="display: block;">
                    <div class="table-responsive">
                        <table class="table no-margin">
                            <thead>
                            <tr>
                                <th>水果品种</th>
                                <th>照片</th>
                                <th>水果名</th>
                                <th>价格/斤</th>
                                <th>购买数量</th>
                                <th>原产地</th>
                                <th>商品总价</th>
                                <th>操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:set var="totalPrice" value="0"></c:set>
                            <c:forEach var="cart" items="${cartList}">
                                <c:set var="totalPrice" value="${ totalPrice + (cart.price * cart.quantity)}"/>
                                <tr>
                                    <td>${cart.c_id}</td>
                                    <td><img src="<%=request.getContextPath()%>/${cart.fruit_image}"
                                             style="width: 105px;height: 70px;"
                                             onclick='showimage("<%=request.getContextPath()%>/${cart.fruit_image}")'/>
                                    </td>
                                    <td>${cart.fruit_name}</td>
                                    <td>${cart.price}</td>
                                    <td>
                                        <input type="text"
                                               itemPrice="${cart.price}"
                                               itemId="${cart.id}" value="${cart.quantity}"
                                               class="quantity">
                                    </td>
                                    <td>${cart.source}</td>
                                    <td>${cart.price*cart.quantity}</td>
                                    <td>
                                        <a type="button" class="btn btn-default"
                                           href="<%=request.getContextPath()%>/cart/delete/${cart.id}">删除</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div class="menu-button">
                        <h2>总价：¥<fmt:formatNumber value="${totalPrice}" maxFractionDigits="2" minFractionDigits="2"
                                                  groupingUsed="true"/></h2>
                        <a type="button" class="btn btn-default"
                           href="<%=request.getContextPath()%>/order/toindex">去结算</a>
                    </div>
                </div>
            </div>
        </section>
    </div>
</div>
<%@include file="../commons/tail.jsp"%>
<script>

    function showChoose() {
        $("#chooseType").show();
        locationChange();
    }

    function showimage(source) {
        $("#imgInModalID").attr("src", source);
        $('.modal').show();
    }

    function closeModel() {
        $('.modal').hide();
    }

    function locationChange() {
        var type = "";
        var obj = document.getElementById('typeList');
        obj.options.length = 0;
        $.ajax({
            type: "post",
            url: "/fruit/getParentTypeList",
            cache: false,
            data: {type: type},
            dataType: "json",
            success: function (result) {
                if (result.length > 0) {
                    for (var i in result) {
                        var selectOption = new Option(result[i].name, result[i].cId);
                        obj.add(selectOption);
                    }
                }
            }
        });
    }

    $(".quantity").change(function () {
        var _thisInput = $(this);
        if(parseInt(_thisInput.val())>0&&parseInt(_thisInput.val())<1000){
            var change = confirm("确认修改商品数量吗？(请确保为数字，否则发生错误!");
            if (change = true) {
                window.location.href = "<%=request.getContextPath()%>/cart/updateQuantity/" + _thisInput.attr("itemId") + "/" + _thisInput.val();

            }
        }else {
            alert("请输入正确数字");
            window.location.href = "<%=request.getContextPath()%>/cart/updateQuantity/" + _thisInput.attr("itemId") + "/" + 1;
        }
    })

</script>
</body>
</html>
