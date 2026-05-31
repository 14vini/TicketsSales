using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TicketSales.Contexts.Sales.Domain.Entities;

namespace TicketSales.Contexts.Sales.Repositories
{
    public class InMemoryTicketOrderRepository : ITicketOrderRepository
    {
        // Nossa tabela fake de vendas
        private static readonly List<TicketOrder> _orders = new List<TicketOrder>();

        public void Add(TicketOrder order)
        {
            _orders.Add(order);
        }

        public TicketOrder GetById(Guid id)
        {
            return _orders.FirstOrDefault(o => o.Id == id);
        }

        public List<TicketOrder> GetAll()
        {
            return _orders;
        }
    }
}