using System;
using Microsoft.EntityFrameworkCore;
using TicketSales.Contexts.Events.Domain.Entities;
using TicketSales.Contexts.Sales.Domain.Entities;

namespace TicketSales.Infrastructure.Data
{
    public class TicketSalesDbContext : DbContext
    {
        public TicketSalesDbContext(DbContextOptions<TicketSalesDbContext> options) : base(options)
        {
        }

        // entidades para virar tabelas
        public DbSet<Event> Events { get; set; }
        public DbSet<TicketOrder> TicketOrders { get; set; }

        // configuração extra para o EF saber lidar com o seu Enum de status como número ou string
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<TicketOrder>()
                .Property(t => t.Status)
                .HasConversion<int>(); // Salva como 0, 1 ou 2 no bd
        }
    }
}