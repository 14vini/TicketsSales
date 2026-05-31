using TicketSales.Contexts.Events.Domain.Entities;
using TicketSales.Contexts.Events.Repositories;

namespace TicketSales.Contexts.Events.Application.UseCases
{
    public class CreateEventUseCase
    {
        // readeonly: somente leitura, só pode ser setado no construtor. Garante que o repositório não vai ser trocado no meio do caminho.
        private readonly IEventRepository _repository;

        // O Use Case recebe o repositório pelo construtor (Injeção de Dependência)
        // Ele não sabe qual banco de dados é, só sabe que o repositório tem o método .Add()
        public CreateEventUseCase(IEventRepository repository)
        {
            _repository = repository;
        }

        //executa a ação de criar o evento
        public void Execute(string name, DateTime eventDate, int maxCapacity)
        {
            // 1. Criamos a entidade. 
            // Lembre-se: se a data for no passado ou a capacidade for zerada,
            // a própria entidade vai estourar um erro aqui e o processo para!
            var newEvent = new Event(name, eventDate, maxCapacity);

            // se passou pelas regras da identidade, salva no banco de dados através do repositório
            _repository.Add(newEvent);
        }
    }
}
