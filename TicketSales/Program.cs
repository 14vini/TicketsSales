using TicketSales.Contexts.Events.Repositories;
using TicketSales.Contexts.Events.Application.UseCases;
using TicketSales.Contexts.Sales.Repositories;
using TicketSales.Contexts.Sales.Application.UseCases;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddOpenApi();

// Registrando o nosso repositório fake e o Use Case no sistema de dependências do C#
builder.Services.AddSingleton<IEventRepository, InMemoryEventRepository>();
builder.Services.AddTransient<CreateEventUseCase>();
builder.Services.AddTransient<GetAllEventsUseCase>();

// Registros do Contexto de Vendas (Sales)
builder.Services.AddSingleton<ITicketOrderRepository, InMemoryTicketOrderRepository>();
builder.Services.AddTransient<CreateTicketOrderUseCase>();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.MapControllers();

// Deixei o exemplo do weatherforecast aqui caso queira manter, mas o foco agora é o Controller
var summaries = new[]
{
    "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
};

app.MapGet("/weatherforecast", () =>
{
    var forecast =  Enumerable.Range(1, 5).Select(index =>
        new WeatherForecast
        (
            DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            Random.Shared.Next(-20, 55),
            summaries[Random.Shared.Next(summaries.Length)]
        ))
        .ToArray();
    return forecast;
})
.WithName("GetWeatherForecast");

app.Run();

record WeatherForecast(DateOnly Date, int TemperatureC, string? Summary)
{
    public int TemperatureF => 32 + (int)(TemperatureC / 0.5556);
}
