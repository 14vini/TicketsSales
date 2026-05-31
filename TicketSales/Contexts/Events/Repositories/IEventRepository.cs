using TicketSales.Contexts.Events.Domain.Entities;

namespace TicketSales.Contexts.Events.Repositories
{
    public interface IEventRepository
    {
        // Busca um evento pelo ID dele
        Event? GetById(Guid id);
        // Salva um novo evento no sistema
        void Add(Event myEvent);
        // Atualiza um evento que já existe no sistema
        void Update(Event myEvent);
        List<Event> GetAll();
    }
}
