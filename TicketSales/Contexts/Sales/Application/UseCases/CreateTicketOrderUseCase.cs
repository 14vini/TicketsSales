using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TicketSales.Contexts.Events.Repositories;
using TicketSales.Contexts.Sales.Domain.Entities;
using TicketSales.Contexts.Sales.Repositories;

namespace TicketSales.Contexts.Sales.Application.UseCases
{
    public class CreateTicketOrderUseCase
    {
        private readonly ITicketOrderRepository _salesRepository;
        private readonly IEventRepository _eventRepository; // integrar o repositório de eventos
    
        public CreateTicketOrderUseCase(
            ITicketOrderRepository salesRepository, 
            IEventRepository eventRepository)
        {
            _salesRepository = salesRepository;
            _eventRepository = eventRepository;
        }

        public void Execute(Guid eventId, string customerName, int ticketQuantity)
        {
            // verificando se o evento existe 
            var myEvent = _eventRepository.GetById(eventId);
            if (myEvent == null)
                throw new ArgumentException("The event does not exist.");

            // verifica se tem estoque no banco de dados
            if (!myEvent.CanFitTickets(ticketQuantity))
                throw new InvalidOperationException("Not enough tickets available for this event.");

            // se o evento existe e tem capacidade, criamos a nossa entidade de Venda (TicketOrder)
            var newOrder = new TicketOrder(eventId, customerName, ticketQuantity);

            //Event atualiza o seu próprio estoque interno de ingressos vendidos
            myEvent.ReserveTickets(ticketQuantity);

            // salvando no banco de dados
            _salesRepository.Add(newOrder);

            //atualiza o estado do evento (com os novos ingressos vendidos) no repositório de eventos
            _eventRepository.Update(myEvent);
        }
    }
}