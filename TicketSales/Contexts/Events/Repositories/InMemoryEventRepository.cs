using System;
using System.Collections.Generic;
using System.Linq;
using TicketSales.Contexts.Events.Domain.Entities;

namespace TicketSales.Contexts.Events.Repositories
{
    public class InMemoryEventRepository : IEventRepository
    {
        // Uma lista estática que vai simular a nossa tabela do banco de dados
        private static readonly List<Event> _events = new List<Event>();
        
        public List<Event> GetAll()
        {
            return _events;
        }
        public void Add(Event myEvent)
        {
            _events.Add(myEvent);
        }


        public Event? GetById(Guid id)
        {
            return _events.FirstOrDefault(e => e.Id == id);
        }

        public void Update(Event myEvent)
        {
            var existingEvent = GetById(myEvent.Id);
            if (existingEvent != null)
            {
                _events.Remove(existingEvent);
                _events.Add(myEvent);
            }
        }
    }
}
