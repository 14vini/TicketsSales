using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TicketSales.Contexts.Events.Domain.Entities;
using TicketSales.Contexts.Events.Repositories;

namespace TicketSales.Contexts.Events.Application.UseCases
{
    public class GetAllEventsUseCase
    {
        private readonly IEventRepository _repository;

        public GetAllEventsUseCase(IEventRepository repository)
        {
            _repository = repository;
        }

        public List<Event> Execute()
        {
            return _repository.GetAll();
        }
    }
}