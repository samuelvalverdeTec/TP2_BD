using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Tarea2.Models
{
    public class ArticuloRequest {
        public int idUsuarioActual;
        public int accion;
        public string postIP;
        public int ? filtroIdClase;
        public string filtroNombre;
        public int ? filtroCantidad;
    }
}