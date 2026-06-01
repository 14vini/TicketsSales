using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TicketSales.Contexts.Sales.Domain.Entities;

namespace TicketSales.Contexts.Sales.Repositories
{
    public interface ITicketOrderRepository
    {
        //salvar uma nova venda
        void Add(TicketOrder order);
        TicketOrder GetById(Guid id);
        List<TicketOrder> GetAll();
        void Update(TicketOrder order);
    }
}