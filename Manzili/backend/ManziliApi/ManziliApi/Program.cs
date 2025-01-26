using Manzili.Core.Entities;
using Manzili.Core.Mapper;
using Manzili.Core.Repositories;
using Manzili.Core.Services;
using Manzili.EF.RepoistpryImpelemation;
using Mapster;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();


#region DbContext
builder.Services.AddDbContext<ManziliDbContext>(options =>
       options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));
#endregion

#region  Dependency Injection 

builder.Services.AddScoped(typeof(IRepository<>), typeof(Repository<>));
builder.Services.AddScoped( typeof(UserServices));
builder.Services.AddScoped(typeof(StoreServices));
builder.Services.AddScoped(typeof(AuthenticationServices));

#endregion


builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAllOrigins",
        builder =>
        {
            builder.AllowAnyOrigin()
                   .AllowAnyMethod()
                   .AllowAnyHeader();
        });
});


// Add Identity
builder.Services.AddIdentity<User, Role>(option =>
{
    // Password settings
    option.Password.RequireDigit = true;
    option.Password.RequireLowercase = true;
    option.Password.RequireUppercase = true;
    option.Password.RequiredLength = 6;
    option.Password.RequiredUniqueChars = 1;
    option.Password.RequireNonAlphanumeric = true;

    // Lockout settings
    option.Lockout.DefaultLockoutTimeSpan = TimeSpan.FromMinutes(5);
    option.Lockout.MaxFailedAccessAttempts = 5;
    option.Lockout.AllowedForNewUsers = true;

    // User settings
    option.User.RequireUniqueEmail = false;
    // option.User.AllowedUserNameCharacters = ""
}).AddEntityFrameworkStores<ManziliDbContext>().AddDefaultTokenProviders();

#region jwtSettings
var jwtSettings = new JwtSettings();
builder.Configuration.GetSection("Jwt").Bind(jwtSettings);
builder.Services.AddSingleton(jwtSettings);
#endregion

MapsterConfig.RegisterMappings();




var app = builder.Build();

app.UseCors("AllowAllOrigins");

//// Configure the HTTP request pipeline.
//if (app.Environment.IsDevelopment())
//{
//    app.UseSwagger();
//    app.UseSwaggerUI();
//}

app.UseSwagger();
app.UseSwaggerUI();

app.UseHttpsRedirection();

app.UseAuthorization();
app.MapControllers();

app.Run();
