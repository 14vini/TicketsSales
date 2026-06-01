using System.Text.Json.Serialization;
using Microsoft.EntityFrameworkCore;
using TicketSales.Infrastructure.Data;
//Use Cases
using TicketSales.Contexts.Events.Application.UseCases;
using TicketSales.Contexts.Sales.Application.UseCases;
//Interfaces
using TicketSales.Contexts.Events.Domain.Entities;
using TicketSales.Contexts.Events.Repositories;
using TicketSales.Contexts.Sales.Repositories;

var builder = WebApplication.CreateBuilder(args);

// controllers 
builder.Services.AddControllers().AddJsonOptions(options =>
{
    // Avisa o C# para transformar os Enums em String na hora de gerar o JSON no Swagger/Postman
    options.JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter());
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddOpenApi();


// ------------------------------------------------------------------------------------------------
//Use Cases :

//Events
builder.Services.AddTransient<CreateEventUseCase>();
builder.Services.AddTransient<GetAllEventsUseCase>();

// sales
builder.Services.AddTransient<CreateTicketOrderUseCase>();
builder.Services.AddTransient<GetAllTicketOrdersUseCase>();
builder.Services.AddTransient<ApprovePaymentUseCase>();
// ------------------------------------------------------------------------------------------------
//DB Context e Repositórios:

//repositório e injetar a dependência do DbContext
builder.Services.AddScoped<IEventRepository, EventRepository>();
builder.Services.AddScoped<ITicketOrderRepository, TicketOrderRepository>();

// DB config
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
var mySqlServerVersion = new MySqlServerVersion(new Version(8, 0, 36));

builder.Services.AddDbContext<TicketSalesDbContext>(options =>
    options.UseMySql(connectionString, mySqlServerVersion));

// ------------------------------------------------------------------------------------------------

var app = builder.Build();

// swagger ambiente
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.MapControllers();

app.Run();