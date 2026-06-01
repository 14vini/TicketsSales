using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.Configuration;

namespace TicketSales.Infrastructure.Data
{
    public class TicketSalesDbContextFactory : IDesignTimeDbContextFactory<TicketSalesDbContext>
    {
        public TicketSalesDbContext CreateDbContext(string[] args)
        {
            var basePath = Directory.GetCurrentDirectory();

            if (!File.Exists(Path.Combine(basePath, "appsettings.json")))
            {
                var projectPath = Path.Combine(basePath, "TicketSales");
                if (File.Exists(Path.Combine(projectPath, "appsettings.json")))
                {
                    basePath = projectPath;
                }
            }

            var configuration = new ConfigurationBuilder()
                .SetBasePath(basePath)
                .AddJsonFile("appsettings.json", optional: false)
                .AddJsonFile("appsettings.Development.json", optional: true)
                .Build();

            var connectionString = configuration.GetConnectionString("DefaultConnection")
                ?? throw new InvalidOperationException("Connection string 'DefaultConnection' was not found.");

            var optionsBuilder = new DbContextOptionsBuilder<TicketSalesDbContext>();
            var mySqlServerVersion = new MySqlServerVersion(new Version(8, 0, 36));

            optionsBuilder.UseMySql(connectionString, mySqlServerVersion);

            return new TicketSalesDbContext(optionsBuilder.Options);
        }
    }
}
