using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TicketSales.Contexts.Sales.Repositories;

namespace TicketSales.Contexts.Sales.Application.UseCases
{
    public class ApprovePaymentUseCase
    {
        private readonly ITicketOrderRepository _repository;

        public ApprovePaymentUseCase(ITicketOrderRepository repository)
        {
            _repository = repository;
        }

        public void Execute(Guid orderId)
        {
            // 1. Busca a venda no repositório pelo ID
            var order = _repository.GetById(orderId);
            if (order == null)
                throw new ArgumentException("Ticket order not found.");

            // 2. Chama o método de negócio da própria ENTIDADE para alterar o status
            order.ApprovePayment();

            _repository.Update(order);
        }
    }
}