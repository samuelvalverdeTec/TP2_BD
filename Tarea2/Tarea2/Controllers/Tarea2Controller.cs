using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Tarea2.Models;

namespace Tarea2.Controllers
{
    public class Tarea2Controller : ApiController
    {
        public string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;

        [HttpPost]
        [Route("articulos")]
        public IHttpActionResult getArticulos(ArticuloRequest request)
        {
            ArticuloListResult result = new ArticuloListResult();
            try
            {
                using (SqlConnection con = new SqlConnection(constr))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("Obtener_Articulos_Orden_Alfabetico"))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Connection = con;
                        cmd.CommandTimeout = 60;
                        cmd.Parameters.Add(new SqlParameter("@inIdUsuarioActual", request.idUsuarioActual)); ;
                        cmd.Parameters.Add(new SqlParameter("@inAccion", request.accion));
                        cmd.Parameters.Add(new SqlParameter("@inPostIP", request.postIP));
                        if (request.filtroIdClase.HasValue)
                        {
                            cmd.Parameters.Add(new SqlParameter("@inFiltroIdClase", request.filtroIdClase.Value));
                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@inFiltroIdClase", DBNull.Value));
                        }
                        cmd.Parameters.Add(new SqlParameter("@inFiltroNombre", request.filtroNombre));
                        if (request.filtroCantidad.HasValue)
                        {
                            cmd.Parameters.Add(new SqlParameter("@inFiltroCantidad", request.filtroCantidad.Value));
                        }
                        else
                        {
                            cmd.Parameters.Add(new SqlParameter("@inFiltroCantidad", DBNull.Value));
                        }                    
                        SqlParameter return_Value = new SqlParameter("@outResultCode", SqlDbType.Int);
                        return_Value.Direction = ParameterDirection.Output;
                        cmd.Parameters.Add(return_Value);
                        result.ListaArticulos = new List<Articulo>();
                        SqlDataReader reader = cmd.ExecuteReader();
                        if(return_Value.Value != DBNull.Value)
                        {
                            int resultado = Convert.ToInt32(return_Value.Value);
                            if (resultado == 0)
                            {
                                while (reader.Read())
                                {
                                    Articulo articulo = new Articulo();
                                    articulo.id = Convert.ToInt32(reader["id"]);
                                    articulo.idClaseArticulo = Convert.ToInt32(reader["IdClaseArticulo"]);
                                    articulo.Codigo = reader["Codigo"].ToString();
                                    articulo.Nombre = reader["Nombre"].ToString();
                                    articulo.Precio = Convert.ToDouble(reader["Precio"]);
                                    articulo.NombreClase = reader["NombreClase"].ToString();
                                    result.ListaArticulos.Add(articulo);
                                }
                            }
                            else
                            {
                                result.CodigoError = resultado;
                                result.Mensaje = "Error inesperado: " + resultado;
                            }
                        }
                        else
                        {
                            result.CodigoError = 4;
                            result.Mensaje = "Error inesperado: ";
                        }
                    }
                    con.Close();
                }
            }
            catch (Exception exc)
            {
                result.CodigoError = 1;
                result.Mensaje = "Error inesperado " + exc.Message;
            }

            string jsonResult = JsonConvert.SerializeObject(result);
            return Ok(jsonResult);
        }


        [HttpGet]
        [Route("clasesArticulos")]
        public IHttpActionResult getClasesArticulos()
        {
            ClaseArticuloListResult result = new ClaseArticuloListResult();
            try
            {
                using (SqlConnection con = new SqlConnection(constr))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("Obtener_Clases_Articulos"))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Connection = con;
                        cmd.CommandTimeout = 60;
                        SqlParameter return_Value = new SqlParameter("@outResultCode", SqlDbType.Int);
                        return_Value.Direction = ParameterDirection.Output;
                        cmd.Parameters.Add(return_Value);
                        result.ListaClaseArticulos = new List<ClaseArticulo>();
                        SqlDataReader reader = cmd.ExecuteReader();
                        if (return_Value.Value != DBNull.Value)
                        {
                            int resultado = Convert.ToInt32(return_Value.Value);
                            if (resultado == 0)
                            {
                                while (reader.Read())
                                {
                                    ClaseArticulo claseArticulo = new ClaseArticulo();
                                    claseArticulo.id = Convert.ToInt32(reader["id"]);
                                    claseArticulo.Nombre = reader["Nombre"].ToString();
                                    result.ListaClaseArticulos.Add(claseArticulo);
                                }
                            }
                            else
                            {
                                result.CodigoError = resultado;
                                result.Mensaje = "Error inesperado: " + resultado;
                            }
                        }
                        else
                        {
                            result.CodigoError = 5;
                            result.Mensaje = "Error inesperado ";
                        }
                    }
                    con.Close();
                }
            }
            catch (Exception exc)
            {
                result.CodigoError = 2;
                result.Mensaje = "Error inesperado: " + exc.Message;
            }

            string jsonResult = JsonConvert.SerializeObject(result);
            return Ok(jsonResult);
        }



        [HttpPost]
        [Route("insertarArticulo")]
        public IHttpActionResult insertarArticulo(ArticuloInsertRequest request)
        {
            ArticuloInsertResult result = new ArticuloInsertResult();
            try
            {
                using (SqlConnection con = new SqlConnection(constr))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("Insertar_Articulo"))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Connection = con;
                        cmd.CommandTimeout = 60;
                        cmd.Parameters.Add(new SqlParameter("@inIdUsuarioActual", request.idUsuarioActual)); ;
                        cmd.Parameters.Add(new SqlParameter("@inPostIP", request.postIP));
                        cmd.Parameters.Add(new SqlParameter("@inIdClaseArticulo", request.idClaseArticulo));
                        cmd.Parameters.Add(new SqlParameter("@inCodigo", request.Codigo));
                        cmd.Parameters.Add(new SqlParameter("@inNombre", request.Nombre));
                        cmd.Parameters.Add(new SqlParameter("@inPrecio", request.Precio));
                        SqlParameter return_Value = new SqlParameter("@outResultCode", SqlDbType.Int);
                        return_Value.Direction = ParameterDirection.Output;
                        cmd.Parameters.Add(return_Value);
                        SqlDataReader reader = cmd.ExecuteReader();
                        if (return_Value.Value != DBNull.Value)
                        {
                            int resultado = Convert.ToInt32(return_Value.Value);
                            if (resultado == 0)
                            {
                                result.CodigoError = 0;
                                result.Mensaje = "Se insertó el artículo correctamente";
                            }
                            else
                            {
                                result.CodigoError = resultado;
                                if (resultado == 50003)
                                {
                                    result.Mensaje = "Error insertando: El artículo ya existe";
                                }
                                else if(resultado == 50004)
                                {
                                    result.Mensaje = "Error inesperado: " + resultado;
                                }                                
                            }
                        }
                        else
                        {
                            result.CodigoError = 6;
                            result.Mensaje = "Error inesperado";
                        }
                    }
                    con.Close();
                }
            }
            catch (Exception exc)
            {
                result.CodigoError = 3;
                result.Mensaje = "Error inesperado: " + exc.Message;
            }

            string jsonResult = JsonConvert.SerializeObject(result);
            return Ok(jsonResult);
        }




        [HttpPost]
        [Route("usuario")]
        public IHttpActionResult getUsuario(UsuarioRequest request)
        {
            UsuarioResult result = new UsuarioResult();
            try
            {
                using (SqlConnection con = new SqlConnection(constr))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("Validar_Usuario"))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Connection = con;
                        cmd.CommandTimeout = 60;
                        cmd.Parameters.Add(new SqlParameter("@inPostIP", request.postIP));
                        cmd.Parameters.Add(new SqlParameter("@inUsuarioActual", request.parametroNombre));
                        cmd.Parameters.Add(new SqlParameter("@inPassword", request.parametroPassword));
                        SqlParameter return_Value = new SqlParameter("@outResultCode", SqlDbType.Int);
                        return_Value.Direction = ParameterDirection.Output;
                        cmd.Parameters.Add(return_Value);
                        result.Usuario = new Usuario();
                        SqlDataReader reader = cmd.ExecuteReader();
                        if (return_Value.Value != DBNull.Value)
                        {
                            int resultado = Convert.ToInt32(return_Value.Value);
                            if (resultado == 0)
                            {
                                while (reader.Read())
                                {
                                    Usuario usuario = new Usuario();
                                    usuario.id = Convert.ToInt32(reader["id"]);
                                    usuario.Nombre = reader["UserName"].ToString();
                                    usuario.Password = reader["Password"].ToString();
                                    result.Usuario = usuario;
                                }
                            }
                            else
                            {
                                result.CodigoError = resultado;
                                result.Mensaje = "Error inesperado: " + resultado;
                            }
                        }
                        else
                        {
                            result.CodigoError = 7;
                            result.Mensaje = "Error inesperado: ";
                        }
                    }
                    con.Close();
                }
            }
            catch (Exception exc)
            {
                result.CodigoError = 8;
                result.Mensaje = "Error inesperado " + exc.Message;
            }

            string jsonResult = JsonConvert.SerializeObject(result);
            return Ok(jsonResult);
        }





        // GET api/values
        [HttpGet]
        [Route("get")]
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET api/values/5
        [HttpGet]
        [Route("getVal")]
        public string Get(int id)
        {
            return "value";
        }

        // POST api/values
        public void Post([FromBody]string value)
        {
        }

        // PUT api/values/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/values/5
        public void Delete(int id)
        {
        }
    }
}
