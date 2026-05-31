using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

public enum OrderStatus
{
    Pending,
    Approved,
    Canceled
}

namespace TicketSales.Contexts.Sales.Domain.Entities
{
public class TicketOrder
{
    // 1. Propriedades
    public Guid Id { get; private set; }
    public Guid EventId { get; private set; } //referência do ID do outro contexto
    public string CustomerName { get; private set; }
    public int TicketQuantity { get; private set; }
    public OrderStatus Status { get; private set; }

    public TicketOrder(Guid eventId, string customerName, int ticketQuantity)
    {
        Id = Guid.NewGuid();
        EventId = eventId;
        CustomerName = customerName;
        TicketQuantity = ticketQuantity;
        Status = OrderStatus.Pending; // venda começa como Pendente
    }
    public void ApprovePayment()
    {
        if (Status != OrderStatus.Pending)
            throw new Exception("Only pending orders can be approved.");

        Status = OrderStatus.Approved;
    }

    // Só cancela se não tiver sido cancelada antes
    public void CancelOrder()
    {
        if (Status == OrderStatus.Canceled)
            throw new Exception("Order is already canceled.");

        Status = OrderStatus.Canceled;
    }
}
}
