using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TicketSales.Contexts.Events.Domain.Entities
{
    public class Event
    {
        public Guid Id { get; private set; }
        public string Name { get; private set; }
        public DateTime EventDate { get; private set; }
        public int MaxCapacity { get; private set; }
        public int TicketsSold { get; private set; }

        // 2. Construtor
        public Event(string name, DateTime eventDate, int maxCapacity)
        {
            Id = Guid.NewGuid();
            Name = name;
            EventDate = eventDate;
            MaxCapacity = maxCapacity;
            TicketsSold = 0; // evento começa sem ingressos vendidos
        }

        // nao pode vender se o evento já passou
        public bool IsPastEvent()
        {
            return DateTime.Now > EventDate;
        }

        // nao pode vender se estourar a capacidade
        public bool CanFitTickets(int quantity)
        {
            return (TicketsSold + quantity) <= MaxCapacity;
        }

        // Ação que altera o estado respeitando as regras acima
        public void ReserveTickets(int quantity)
        {
            if (IsPastEvent())
                throw new Exception("Cannot reserve tickets for a past event.");

            if (!CanFitTickets(quantity))
                throw new Exception("Not enough tickets available for this event.");

            TicketsSold += quantity;
        }
    }
}
