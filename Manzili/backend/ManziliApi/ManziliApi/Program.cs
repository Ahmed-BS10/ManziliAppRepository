using Manzili.Core.Entities;
using Manzili.Core.Extension;
using Manzili.Core.Mapper;
using Manzili.Core.Services;
using Manzili.EF.Extension;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);

// ≈÷«›… «·Œœ„«  ≈·Ï «·Õ«ÊÌ…
builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles;
        options.JsonSerializerOptions.DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull;
        options.JsonSerializerOptions.WriteIndented = true;
    });

// ≈⁄œ«œ Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// ≈⁄œ«œ ﬁ«⁄œ… «·»Ì«‰« 
builder.Services.AddDbContext<ManziliDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// ≈÷«›… «·Œœ„«  (Dependency Injection)
builder.Services.AddApplicationServices();
builder.Services.AddInfrastructureServices();

// ≈⁄œ«œ CORS
const string CorsPolicy = "AllowAll";
builder.Services.AddCors(options =>
{
    options.AddPolicy(CorsPolicy, policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// ≈⁄œ«œ «·ÂÊÌ… (Identity)
builder.Services.AddIdentity<User, Role>(options =>
{
    // ≈⁄œ«œ«  ﬂ·„… «·„—Ê—
    options.Password.RequireDigit = true;
    options.Password.RequireLowercase = true;
    options.Password.RequireUppercase = true;
    options.Password.RequiredLength = 6;
    options.Password.RequiredUniqueChars = 1;
    options.Password.RequireNonAlphanumeric = true;

    // ≈⁄œ«œ«  «·≈€·«ﬁ
    options.Lockout.DefaultLockoutTimeSpan = TimeSpan.FromMinutes(5);
    options.Lockout.MaxFailedAccessAttempts = 5;
    options.Lockout.AllowedForNewUsers = true;

    // ≈⁄œ«œ«  «·„” Œœ„
    options.User.RequireUniqueEmail = false;
})
.AddEntityFrameworkStores<ManziliDbContext>()
.AddDefaultTokenProviders();

// ≈⁄œ«œ JWT
var jwtSettings = new JwtSettings();
builder.Configuration.GetSection("Jwt").Bind(jwtSettings);
builder.Services.AddSingleton(jwtSettings);

var app = builder.Build();

//  „ﬂÌ‰ CORS
app.UseCors(CorsPolicy);







using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    try
    {
        var context = services.GetRequiredService<ManziliDbContext>();
        SeedData.Initialize(context);
    }
    catch (Exception ex)
    {
        var logger = services.GetRequiredService<ILogger<Program>>();
        logger.LogError(ex, "An error occurred while seeding the database.");
    }
}




//  „ﬂÌ‰ Swagger ›Ì Ê÷⁄ «· ÿÊÌ— ›ﬁÿ
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseStaticFiles();
app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.Run();
