using System;
using System.Collections.Generic;
using System.Linq;
using TicketSales.Contexts.Sales.Domain.Entities;
using TicketSales.Infrastructure.Data;

namespace TicketSales.Contexts.Sales.Repositories
{
    public class TicketOrderRepository : ITicketOrderRepository
    {
        private readonly TicketSalesDbContext _context;

        public TicketOrderRepository(TicketSalesDbContext context)
        {
            _context = context;
        }

        public void Add(TicketOrder order)
        {
            _context.TicketOrders.Add(order);
            _context.SaveChanges();
        }
        public void Update(TicketOrder order)
        {
            _context.TicketOrders.Update(order);
            _context.SaveChanges(); 
        }

        public TicketOrder GetById(Guid id)
        {
            return _context.TicketOrders.FirstOrDefault(o => o.Id == id);
        }

        public List<TicketOrder> GetAll()
        {
            return _context.TicketOrders.ToList();
        }
    }
}