using Manzili.Core.Entities;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;


public class ManziliDbContext : IdentityDbContext<User, Role, int>
{
    public ManziliDbContext(DbContextOptions<ManziliDbContext> dbContextOptions) : base(dbContextOptions)
    {
    }

    public DbSet<User> Users { get; set; }
    public DbSet<Store> Stores { get; set; }
    public DbSet<Category> Categories { get; set; }
    public DbSet<StoreCategoryStore> StoreCategoryStores { get; set; }
    public DbSet<StoreCategory> StoreCategories { get; set; }
    public DbSet<StoreRating> StoreRatings { get; set; }
    public DbSet<Favorite> Favorites { get; set; }






    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);


        modelBuilder.Entity<User>().ToTable("Users");
        modelBuilder.Entity<Store>().ToTable("Stores");



        modelBuilder.Entity<Store>()
            .HasMany(s => s.storeCategoryStores)
            .WithOne(sc => sc.Store)
            .HasForeignKey(sc => sc.StoreId);



        modelBuilder.Entity<StoreCategory>()
           .HasMany(s => s.StoreCategoriesStores)
           .WithOne(sc => sc.StoreCategory)
           .HasForeignKey(sc => sc.StoreCategoryId);




        modelBuilder.Entity<StoreRating>()
             .HasOne(r => r.User)
             .WithMany(u => u.RatingsGivenStore)
             .HasForeignKey(r => r.UserId)
             .OnDelete(DeleteBehavior.NoAction);

        modelBuilder.Entity<StoreRating>()
            .HasOne(r => r.Store)
            .WithMany(s => s.RatingsReceived)
            .HasForeignKey(r => r.StoreId)
            .OnDelete(DeleteBehavior.NoAction);



        modelBuilder.Entity<Favorite>()
            .HasOne(f => f.User)
            .WithMany(u => u.FavoritesStore)
            .HasForeignKey(f => f.UserId)
            .OnDelete(DeleteBehavior.NoAction);


        modelBuilder.Entity<Favorite>()
            .HasOne(f => f.Store)
            .WithMany(s => s.Favorites)
            .HasForeignKey(f => f.StoreId)
            .OnDelete(DeleteBehavior.NoAction);


    }



    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        base.OnConfiguring(optionsBuilder);

        optionsBuilder.UseSqlServer("Server=db13966.Public.databaseasp.net; Database=db13966; User Id=db13966; Password=4Rb#X+6og2L_; Encrypt=False; MultipleActiveResultSets=True;")
            .LogTo(Console.WriteLine, Microsoft.Extensions.Logging.LogLevel.Information);


    }



}



