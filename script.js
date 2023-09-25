$(document).ready(function() {
    // API URL to fetch articles
    const apiUrlArticulos = 'http://localhost/Tarea2/articulos';
    const apiUrlClaseArtic = 'http://localhost/Tarea2/clasesArticulos';
    const apiUrlInsertar = 'http://localhost/Tarea2/insertarArticulo';
    const apiUrlValModif = 'http://localhost/Tarea2/validarModificarArticulo';
    const apiUrlModificar = 'http://localhost/Tarea2/modificarArticulo';
    const apiUrlValBorrar = 'http://localhost/Tarea2/validarBorrarArticulo';
    const apiUrlBorrar = 'http://localhost/Tarea2/borrarArticulo';
    //const apiUrlUsuario = 'http://localhost/Tarea2/usuario';

    var idUsuarioAct = getQueryStringValues('idUsuario');
    var postIP = "localhost";
    var idArticuloBuscado = 0;
    //console.log(getQueryStringValues('idUsuario'));

    function mostrarClaseArticulos() {
        $.ajax({
            url: apiUrlClaseArtic,
            method: 'GET',
            dataType: 'json',
            success: function(data) {
                const articleClassesList = $('#fClaseArtic');
                const articleClassesListInsertar = $('#ClasesArticulosInsertar');
                const articleClassesListModificar = $('#ClasesArticulosModificar');
                articleClassesList.empty();
                articleClassesListInsertar.empty();
                data = JSON.parse(data);
                articleClassesList.append($('<option>', {
                    value: -1,
                    text: 'todos'
                }));
                articleClassesListInsertar.append($('<option>', {
                    value: -1,
                    text: 'seleccione una clase'
                }));
                articleClassesListModificar.append($('<option>', {
                    value: -1,
                    text: 'seleccione una clase'
                }));
                if(data.CodigoError == 0){
                    // Iterar lista de articulos
                    data.ListaClaseArticulos.forEach(function(articleClass) {
                        // Create list item for each article
                        articleClassesList.append($('<option>', {
                            value: articleClass.id,
                            text: articleClass.Nombre
                        }));
                        articleClassesListInsertar.append($('<option>', {
                            value: articleClass.id,
                            text: articleClass.Nombre
                        }));
                        articleClassesListModificar.append($('<option>', {
                            value: articleClass.id,
                            text: articleClass.Nombre
                        }));
                    });
                }
                else{
                    alert('Error: ' + data.CodigoError);
                }
            },
            error: function(error) {
                console.error('Error buscando artículos:', error);
            }
        });
    }

    function mostrarArticulos(idUsuarioAct, accion, postIP, filtroIdClase, filtroNombre, filtroCantidad) {
        $.ajax({
        type: "POST",
        url: apiUrlArticulos,
        method: 'POST',
        contentType: "application/json",
        crossDomain: true,
        data: JSON.stringify({
            "idUsuarioActual": idUsuarioAct,
            "accion": accion,
            "postIP": postIP,
            "filtroIdClase": filtroIdClase,
            "filtroNombre": filtroNombre,
            "filtroCantidad": filtroCantidad
        }),
        success: function(data) {
            const articleList = $('#listArticulo');
            articleList.empty();
            data = JSON.parse(data);
            if(data.CodigoError == 0){
                // Iterar lista de articulos

                const listItem = $('<li class="list-group-item"></li>');

                // Create content for the list item
                const articClase = $('<div class="col-3"><b>Clase Artículo</b> </div>');
                const articCode = $('<div class="col-2"><b>Codigo</b> </div>');
                const articDescripcion = $('<div class="col-4"><b>Nombre</b> </div>');
                const articPrecio = $('<div class="col-2"><b>Precio</b> </div>');
                

                //const articDescripcion = $('<p>' + article.nombre + '</p>');
                //const articPrecio = $('<p>Precio: $' + article.precio + '</p>');

                //listItem.append(articDescripcion);
                //listItem.append(articPrecio);
                const divArtic = ($('<div class="row"> </div>'));
                listItem.append(divArtic);
                divArtic.append(articClase);
                divArtic.append(articCode);
                divArtic.append(articDescripcion);
                divArtic.append(articPrecio);

                articleList.append(listItem);

                data.ListaArticulos.forEach(function(article) {
                    // Create list item for each article
                    const listItem = $('<li class="list-group-item"></li>');

                    // Create content for the list item
                    const articClase = $('<div class="col-3">' + article.NombreClase + '</div>');
                    const articCode = $('<div class="col-2">' + article.Codigo + '</div>');
                    const articDescripcion = $('<div class="col-4">' + article.Nombre + '</div>');
                    const articPrecio = $('<div class="col-2">' + article.Precio + '</div>');
                    

                    //const articDescripcion = $('<p>' + article.nombre + '</p>');
                    //const articPrecio = $('<p>Precio: $' + article.precio + '</p>');

                    //listItem.append(articDescripcion);
                    //listItem.append(articPrecio);
                    const divArtic = ($('<div class="row"> </div>'));
                    listItem.append(divArtic);
                    divArtic.append(articClase);
                    divArtic.append(articCode);
                    divArtic.append(articDescripcion);
                    divArtic.append(articPrecio);

                    articleList.append(listItem);
                });
            }
            else{
                alert('Error: ' + data.CodigoError);
            }
        },
        error: function(error) {
            console.error('Error buscando artículos:', error);
        }
        });        
    }


    function insertarArticulo(idUsuarioAct, postIP, idClaseArticulo, codigo, nombre, precio) {
        $.ajax({
        type: "POST",
        url: apiUrlInsertar,
        method: 'POST',
        contentType: "application/json",
        crossDomain: true,
        data: JSON.stringify({
            "idUsuarioActual": idUsuarioAct,
            "postIP": postIP,
            "idClaseArticulo": idClaseArticulo,
            "Codigo": codigo,
            "Nombre": nombre,
            "Precio": precio
        }),
        success: function(data) {
            data = JSON.parse(data);
            if(data.CodigoError == 0){
                alert("datos insertados ");
                mostrarArticulos(idUsuarioAct, 0, postIP, null, '', null);
                limpiarForm();
            }
            else{
                alert(data.Mensaje);
                //limpiarForm();
            }
        },
        error: function(error) {
        alert("error insertando");
        console.error('Error buscando artículos:', error);
        limpiarForm();
        }
        });        
    }

    function validarArticuloModif(idUsuarioAct, postIP, codigo) {
        $('#Modificar_PopUp #datosModif').hide();
        $('#Modificar_PopUp #btnModificar').hide();
        $.ajax({
        type: "POST",
        url: apiUrlValModif,
        method: 'POST',
        contentType: "application/json",
        crossDomain: true,
        data: JSON.stringify({
            "idUsuarioActual": idUsuarioAct,
            "postIP": postIP,
            "Codigo": codigo,
        }),
        success: function(data) {
            data = JSON.parse(data);
            if(data.CodigoError == 0){

                //data.ListaUsuario.forEach(function(article) 
                //llamar pop-up modificar
                //llamar metodo de modificar
                //alert('El artículo con ese código sí existe');
                idArticuloBuscado = data.articulo.id;

                mostrarInfoModificar(data.articulo.idClaseArticulo, data.articulo.Codigo, data.articulo.Nombre, data.articulo.Precio);

                $('#Modificar_PopUp #datosModif').show();
                $('#Modificar_PopUp #btnModificar').show();
            }
            else{
                alert('Error: ' + data.CodigoError + ' No existe un artículo con ese código');
            }
        },
        error: function(error) {
            console.error('Error buscando usuario:', error);
        }
        });        
    }

    function modificarArticulo(idUsuarioAct, postIP, idArticuloBuscado, idClaseArticulo, codigo, nombre, precio) {
        $.ajax({
        type: "POST",
        url: apiUrlModificar,
        method: 'POST',
        contentType: "application/json",
        crossDomain: true,
        data: JSON.stringify({
            "idUsuarioActual": idUsuarioAct,
            "postIP": postIP,
            "idArticuloBuscado": idArticuloBuscado,
            "idClaseArticulo": idClaseArticulo,
            "Codigo": codigo,
            "Nombre": nombre,
            "Precio": precio
        }),
        success: function(data) {
            data = JSON.parse(data);
            if(data.CodigoError == 0){
                alert("artículo modificado ");
                mostrarArticulos(idUsuarioAct, 0, postIP, null, '', null);
                limpiarFormModif();
                $('#Modificar_PopUp #datosModif').hide();
                $('#Modificar_PopUp #btnModificar').hide();
            }
            else{
                alert(data.Mensaje);
                //limpiarFormModif();
            }
        },
        error: function(error) {
        alert("error modificando");
        console.error('Error buscando artículos:', error);
        limpiarFormModif();
        }
        });        
    }


    function validarArticuloBorrar(idUsuarioAct, postIP, codigo) {
        $('#Borrar_PopUp #datosBorrar').hide();
        $('#Borrar_PopUp #btnBorrar').hide();
        $.ajax({
        type: "POST",
        url: apiUrlValBorrar,
        method: 'POST',
        contentType: "application/json",
        crossDomain: true,
        data: JSON.stringify({
            "idUsuarioActual": idUsuarioAct,
            "postIP": postIP,
            "Codigo": codigo,
        }),
        success: function(data) {
            data = JSON.parse(data);
            if(data.CodigoError == 0){

                //data.ListaUsuario.forEach(function(article) 
                //llamar pop-up modificar
                //llamar metodo de modificar
                //alert('El artículo con ese código sí existe');
                const articClase = data.articulo.NombreClase;
                const articCode = data.articulo.Codigo;
                const articDescripcion = data.articulo.Nombre;
                const articPrecio = data.articulo.Precio;
                mostrarInfoBorrar(articClase, articCode, articDescripcion, articPrecio)
                $('#Borrar_PopUp #datosBorrar').show();
                $('#Borrar_PopUp #btnBorrar').show();
            }
            else{
                alert('Error: ' + data.CodigoError + ' No existe un artículo con ese código');
            }
        },
        error: function(error) {
            console.error('Error buscando usuario:', error);
        }
        });        
    }

    function borrarArticulo(idUsuarioAct, postIP, codigo) {
        $.ajax({
        type: "POST",
        url: apiUrlBorrar,
        method: 'POST',
        contentType: "application/json",
        crossDomain: true,
        data: JSON.stringify({
            "idUsuarioActual": idUsuarioAct,
            "postIP": postIP,
            "Codigo": codigo,
        }),
        success: function(data) {
            data = JSON.parse(data);
            if(data.CodigoError == 0){
                alert("artículo borrado ");
                mostrarArticulos(idUsuarioAct, 0, postIP, null, '', null);
                limpiarFormBorrar();
                $('#Borrar_PopUp #datosBorrar').hide();
                $('#Borrar_PopUp #btnBorrar').hide();
            }
            else{
                alert(data.Mensaje);
                //limpiarFormBorrar();
            }
        },
        error: function(error) {
        alert("error borrando");
        console.error('Error buscando artículos:', error);
        limpiarFormModif();
        }
        });        
    }


    function getQueryStringValues(key) {
        var arrParamValues = [];
        var url = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
        for (var i = 0; i < url.length; i++) {
            var arrParamInfo = url[i].split('=');
            if (arrParamInfo[0] == key || arrParamInfo[0] == key+'[]') {
                arrParamValues.push(decodeURIComponent(arrParamInfo[1]));
            }
        }
        return (arrParamValues.length > 0 ? (arrParamValues.length == 1 ? arrParamValues[0] : arrParamValues) : null);
    }


    


    mostrarClaseArticulos();
    mostrarArticulos(idUsuarioAct, 0, postIP, null, '', null);



    function limpiarForm(){
        $('#Insertar_PopUp #ClasesArticulosInsertar').val(-1);
        $('#Insertar_PopUp #txtCodigoArticulo').val("");
        $('#Insertar_PopUp #txtNombreArticulo').val("");
        $('#Insertar_PopUp #txtPrecioArticulo').val("");
    }

    function limpiarFormModif(){
        $('#Modificar_PopUp #txtCodigoModif').val("");
        $('#Modificar_PopUp #ClasesArticulosModificar').val(-1);
        $('#Modificar_PopUp #txtCodigoArticuloModif').val("");
        $('#Modificar_PopUp #txtNombreArticuloModif').val("");
        $('#Modificar_PopUp #txtPrecioArticuloModif').val("");
    }

    function limpiarFormBorrar(){
        $('#Borrar_PopUp #txtCodigoBorrar').val("");
        $('#Borrar_PopUp #ClasesArticulosBorrar').text("");
        $('#Borrar_PopUp #CodigoArticuloBorrar').text("");
        $('#Borrar_PopUp #NombreArticuloBorrar').text("");
        $('#Borrar_PopUp #PrecioArticuloBorrar').text("");
    }

    function mostrarInfoBorrar(idClaseArticulo, codigoArticulo, nombreArticulo, precioArticulo){
        $('#Borrar_PopUp #ClasesArticulosBorrar').text(idClaseArticulo);
        $('#Borrar_PopUp #CodigoArticuloBorrar').text(codigoArticulo);
        $('#Borrar_PopUp #NombreArticuloBorrar').text(nombreArticulo);
        $('#Borrar_PopUp #PrecioArticuloBorrar').text(precioArticulo);
    }

    function isNumeric(str) {
        if (typeof str != "string"){
            return false // we only process strings!  
        } 
        return !isNaN(str) && // use type coercion to parse the entirety of the string (`parseFloat` alone does not do this)...
               !isNaN(parseFloat(str)) // ...and ensure strings of whitespace fail
    }

    $('#Insertar_PopUp').on('show.bs.modal', function (event) {
        limpiarForm();
    })
    $('#Modificar_PopUp').on('show.bs.modal', function (event) {
        limpiarFormModif();
    })
    $('#Borrar_PopUp').on('show.bs.modal', function (event) {
        limpiarFormBorrar();
    })

    $('#Insertar_PopUp #btnInsertar').click(function(){
        var idClaseArticulo = $('#Insertar_PopUp #ClasesArticulosInsertar').find(":selected").val();
        var codigoArticulo = $('#Insertar_PopUp #txtCodigoArticulo').val();
        var nombreArticulo = $('#Insertar_PopUp #txtNombreArticulo').val();
        var precioArticulo = $('#Insertar_PopUp #txtPrecioArticulo').val();
        //alert("Nombre: " + nombreArticulo + "   Precio: " + precioArticulo);
        if(idClaseArticulo == -1){
            alert("Seleccione alguna clase de artículo");
        }
        else{
            if(isNumeric(precioArticulo)){
                if(!isNumeric(nombreArticulo)){
                    insertarArticulo(idUsuarioAct, postIP, idClaseArticulo, codigoArticulo, nombreArticulo, precioArticulo);
                }
                else{
                    alert("El nombre debe ser un string");
                }
            }
            else{
                alert("El precio debe ser un valor monetario");
            }
        }
    })

    //$('#Val_Modif_PopUp #btnValModif').click(function(){
    //    var codigoArticulo = $('#Val_Modif_PopUp #txtCodigoModif').val();
    //    validarArticuloModif(idUsuarioAct, postIP, codigoArticulo);
    //})

    $('#openBorrar').click(function(){
        $('#Borrar_PopUp #datosBorrar').hide();
        $('#Borrar_PopUp #btnBorrar').hide();
        $('#Borrar_PopUp').modal();
    })

    $('#openModif').click(function(){
        $('#Modificar_PopUp #datosModif').hide();
        $('#Modificar_PopUp #btnModificar').hide();
        $('#Modificar_PopUp').modal();
    })

    function mostrarInfoModificar(idClaseArticulo, codigoArticulo, nombreArticulo, precioArticulo){
        $('#Modificar_PopUp #ClasesArticulosModificar').val(idClaseArticulo);
        $('#Modificar_PopUp #txtCodigoArticuloModif').val(codigoArticulo);
        $('#Modificar_PopUp #txtNombreArticuloModif').val(nombreArticulo);
        $('#Modificar_PopUp #txtPrecioArticuloModif').val(precioArticulo);
    }

    $('#Modificar_PopUp #btnValModif').click(function(){
        var codigoArticulo = $('#Modificar_PopUp #txtCodigoModif').val();
        validarArticuloModif(idUsuarioAct, postIP, codigoArticulo);
    })

    $('#Modificar_PopUp #btnModificar').click(function(){
        var idClaseArticulo = $('#Modificar_PopUp #ClasesArticulosModificar').find(":selected").val();
        var codigoArticulo = $('#Modificar_PopUp #txtCodigoArticuloModif').val();
        var nombreArticulo = $('#Modificar_PopUp #txtNombreArticuloModif').val();
        var precioArticulo = $('#Modificar_PopUp #txtPrecioArticuloModif').val();
        //alert("Nombre: " + nombreArticulo + "   Precio: " + precioArticulo);
        if(idClaseArticulo == -1){
            alert("Seleccione alguna clase de artículo");
        }
        else{
            if(isNumeric(precioArticulo)){
                if(!isNumeric(nombreArticulo)){
                    modificarArticulo(idUsuarioAct, postIP, idArticuloBuscado, idClaseArticulo, codigoArticulo, nombreArticulo, precioArticulo);
                }
                else{
                    alert("El nombre debe ser un string");
                }
            }
            else{
                alert("El precio debe ser un valor monetario");
            }
        }
    })

    $('#Borrar_PopUp #btnValBorrar').click(function(){
        var codigoArticulo = $('#Borrar_PopUp #txtCodigoBorrar').val();
        validarArticuloBorrar(idUsuarioAct, postIP, codigoArticulo);
    })

    $('#Borrar_PopUp #btnBorrar').click(function(){
        var codigoArticulo = $('#Borrar_PopUp #txtCodigoBorrar').val();
        //alert("Nombre: " + nombreArticulo + "   Precio: " + precioArticulo);
        borrarArticulo(idUsuarioAct, postIP, codigoArticulo);
    })

    
    $('#btnFiltrarClaseArtic').click(function(){
        var idClaseArticulo = $('#fClaseArtic').find(":selected").val();
        // $('#aioConceptName').find(":selected").val();
        mostrarArticulos(idUsuarioAct, 3, postIP, idClaseArticulo, '', null);
    })

    $('#btnFiltrarNombre').click(function(){
        var nombreArticulo = $('#fname').val();
        mostrarArticulos(idUsuarioAct, 1, postIP, null, nombreArticulo, null);
    })

    $('#btnFiltrarCantidad').click(function(){
        var cantidadArticulo = $('#fcantidad').val();
        if(isNumeric(cantidadArticulo) || cantidadArticulo == ''){
            mostrarArticulos(idUsuarioAct, 2, postIP, null, '', cantidadArticulo);
        }
        else{
            alert("El filtro debe ser un valor numérico");
        }
    })

    


});
