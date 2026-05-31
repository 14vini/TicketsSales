using Microsoft.AspNetCore.Mvc;
using TicketSales.Contexts.Events.Application.UseCases;

namespace TicketSales.Contexts.Events.Controllers
{
    [ApiController]
    [Route("api/events")]
    public class EventsController : ControllerBase
    {
        private readonly CreateEventUseCase _createEventUseCase;
        private readonly GetAllEventsUseCase _getAllEventsUseCase;

        // o Controller recebe o Use Case que ele precisa usar pelo construtor (Injeção de Dependência)
        public EventsController(CreateEventUseCase createEventUseCase, GetAllEventsUseCase getAllEventsUseCase)
        {
            _createEventUseCase = createEventUseCase;
            _getAllEventsUseCase = getAllEventsUseCase;
        }

        [HttpPost] // Indica que este método roda quando o frontend enviar um POST para a rota
        public IActionResult Create([FromBody] CreateEventRequest request)
        {
            try
            {
                // O Controller apenas pega os dados brutos que vieram da internet 
                // e repassa para o Use Case trabalhar
                _createEventUseCase.Execute(request.Name, request.EventDate, request.MaxCapacity);

                return StatusCode(201, new { message = "Event created successfully!" });
            }
            catch (ArgumentException ex)
            {
                // se a entidade estourou um erro de validação
                return BadRequest(new { error = ex.Message });
            }
            catch (Exception)
            {
                // Qualquer outro erro inesperado retorna Status 500 (Erro interno do servidor)
                return StatusCode(500, new { error = "An unexpected error occurred." });
            }
        }

        [HttpGet]
        public IActionResult GetAll()
        {
            try
            {
                var events = _getAllEventsUseCase.Execute();
                return Ok(events); // Retorna Status 200 com a lista de eventos em JSON
            }
            catch (Exception)
            {
                return StatusCode(500, new { error = "An unexpected error occurred." });
            }
        }
    }

    // Mapear para o frontend
    public class CreateEventRequest
    {
        public required string Name { get; set; }
        public DateTime EventDate { get; set; }
        public int MaxCapacity { get; set; }
    }
}