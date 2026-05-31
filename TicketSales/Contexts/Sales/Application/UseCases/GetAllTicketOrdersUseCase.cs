using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TicketSales.Contexts.Sales.Domain.Entities;
using TicketSales.Contexts.Sales.Repositories;

namespace TicketSales.Contexts.Sales.Application.UseCases
{
    public class GetAllTicketOrdersUseCase
    {
        private readonly ITicketOrderRepository _repository;

        public GetAllTicketOrdersUseCase(ITicketOrderRepository repository)
        {
            _repository = repository;
        }

        public List<TicketOrder> Execute()
        {
            return _repository.GetAll();
        }
    }
}