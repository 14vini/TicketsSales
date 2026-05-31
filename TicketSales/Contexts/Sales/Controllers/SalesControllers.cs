using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using TicketSales.Contexts.Sales.Application.UseCases;

namespace TicketSales.Contexts.Sales.Controllers
{
    [ApiController]
    [Route("api/sales")]
    public class SalesController : ControllerBase
    {
        private readonly CreateTicketOrderUseCase _createOrderUseCase;

        // O Controller recebe o Use Case que ele precisa usar pelo construtor (Injeção de Dependência)
        public SalesController(CreateTicketOrderUseCase createOrderUseCase)
        {
            _createOrderUseCase = createOrderUseCase;
        }

        [HttpPost] // fazer compra
        public IActionResult Create([FromBody] CreateOrderRequest request)
        {
            try
            {
                _createOrderUseCase.Execute(request.EventId, request.CustomerName, request.TicketQuantity);

                return StatusCode(201, new { message = "Ticket purchase requested successfully! Status: Pending." });
            }
            catch (ArgumentException ex)
            {
                // erros de validação
                return BadRequest(new { error = ex.Message });
            }
            catch (InvalidOperationException ex)
            {
                // erros de regras de negócio
                return BadRequest(new { error = ex.Message });
            }
            catch (Exception)
            {
                //erros inesperados no servidor
                return StatusCode(500, new { error = "An unexpected error occurred." });
            }
        }
    }

    public class CreateOrderRequest
    {
        public Guid EventId { get; set; }
        public required string CustomerName { get; set; }
        public int TicketQuantity { get; set; }
    }
}