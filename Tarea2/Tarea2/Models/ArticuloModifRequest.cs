﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Tarea2.Models
{
    public class ArticuloModifRequest {
        public int idUsuarioActual;
        public string postIP;
        public int idArticuloBuscado;
        public int idClaseArticulo;
        public string Codigo;
        public string Nombre;
        public double Precio;
    }
}