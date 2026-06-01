using System;
using System.Collections.Generic;
using System.Linq;
using TicketSales.Contexts.Events.Domain.Entities;
using TicketSales.Infrastructure.Data;

namespace TicketSales.Contexts.Events.Repositories
{
    public class EventRepository : IEventRepository
    {
        private readonly TicketSalesDbContext _context;

        public EventRepository(TicketSalesDbContext context)
        {
            _context = context;
        }

        public void Add(Event myEvent)
        {
            _context.Events.Add(myEvent);
            _context.SaveChanges(); // É isso aqui que dispara o "INSERT INTO" no MySQL!
        }

        public Event GetById(Guid id)
        {
            return _context.Events.FirstOrDefault(e => e.Id == id); // Faz o "SELECT * FROM Events WHERE Id = ..."
        }

        public List<Event> GetAll()
        {
            return _context.Events.ToList();
        }

        public void Update(Event myEvent)
        {
            _context.Events.Update(myEvent);
            _context.SaveChanges(); // Dispara o "UPDATE" no banco
        }
    }
}