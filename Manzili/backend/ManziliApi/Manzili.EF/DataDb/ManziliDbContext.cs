using Manzili.Core.Entities;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;


public class ManziliDbContext : IdentityDbContext<User, Role, int>
{
    public ManziliDbContext(DbContextOptions<ManziliDbContext> dbContextOptions) : base(dbContextOptions)
    {
        // _encryptionProvider = new GenerateEncryptionProvider("qwerertrtdfg");
    }

    public DbSet<Favorite> Favorites { get; set; }
    public DbSet<StoreRating> StoreRatings { get; set; }
    public DbSet<Order> Orders { get; set; }
    public DbSet<OrderProduct> OrderProducts { get; set; }
    public DbSet<Product> Products { get; set; }
    public DbSet<User> Users { get; set; }
    public DbSet<Store> Stores { get; set; }
    public DbSet<Category> Categories { get; set; }
    public DbSet<SubCategory> SubCategories { get; set; }
    public DbSet<ProductRating> ProductRatings { get; set; }
    public DbSet<Like> Likes { get; set; }
    public DbSet<Comment> Comments { get; set; }



    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);


        modelBuilder.Entity<Store>()
             .ToTable("Store");

        modelBuilder.Entity<User>()

            .ToTable("Users")
            .HasMany(u => u.StoreRatings)
            .WithOne(sr => sr.User)
            .HasForeignKey(sr => sr.UserId);

        modelBuilder.Entity<User>()
            .HasMany(u => u.Orders)
            .WithOne(o => o.User)
            .HasForeignKey(o => o.UserId);

        modelBuilder.Entity<User>()
            .HasMany(u => u.ProductRatings)
            .WithOne(pr => pr.User)
            .HasForeignKey(pr => pr.UserId);

        modelBuilder.Entity<User>()
            .HasMany(u => u.Likes)
            .WithOne(l => l.User)
            .HasForeignKey(l => l.UserId)
            .OnDelete(DeleteBehavior.Cascade);



        // علاقة بين Comment و User
        modelBuilder.Entity<Comment>()
            .HasOne(c => c.User)
            .WithMany(u => u.Comments)
            .HasForeignKey(c => c.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        // Configure Favorite
        modelBuilder.Entity<Favorite>()
            .HasKey(f => f.FavoriteId);

        modelBuilder.Entity<Favorite>()
             .HasOne(f => f.User)
             .WithMany(u => u.Favorites)
             .HasForeignKey(f => f.UserId)
             .OnDelete(DeleteBehavior.Restrict);


        //modelBuilder.Entity<Favorite>()
        //    .HasOne(f => f.Store)
        //    .WithMany()
        //    .HasForeignKey(f => f.StoreId);

        // Configure StoreRating
        modelBuilder.Entity<StoreRating>()
            .HasKey(sr => sr.StoreRatingId);

        //modelBuilder.Entity<StoreRating>()
        //    .HasOne(sr => sr.st)
        //    .WithMany()
        //    .HasForeignKey(sr => sr.StoreId);

        // Configure Order
        modelBuilder.Entity<Order>()
            .HasKey(o => o.OrderId);

        modelBuilder.Entity<Order>()
            .HasOne(o => o.User)
            .WithMany()
            .HasForeignKey(o => o.UserId);

        modelBuilder.Entity<Order>()
            .HasMany(o => o.OrderProducts)
            .WithOne(op => op.Order)
            .HasForeignKey(op => op.OrderId);

        // Configure OrderProduct
        modelBuilder.Entity<OrderProduct>()
            .HasKey(op => op.OrderProductId);

        modelBuilder.Entity<OrderProduct>()
            .HasOne(op => op.Product)
            .WithMany(p => p.OrderProducts)
            .HasForeignKey(op => op.ProductId)
            .OnDelete(DeleteBehavior.Restrict);


        // Configure Product
        modelBuilder.Entity<Product>()
            .HasKey(p => p.ProductId);

        modelBuilder.Entity<Product>()
            .HasOne(p => p.Category)
            .WithMany(c => c.Products)
            .HasForeignKey(p => p.CategoryId);

        modelBuilder.Entity<Product>()
            .HasOne(p => p.Store)
            .WithMany(s => s.Products)
            .HasForeignKey(p => p.StoreId);

        modelBuilder.Entity<Product>()
            .HasMany(p => p.ProductRatings)
            .WithOne(pr => pr.Product)
            .HasForeignKey(pr => pr.ProductId)
            .OnDelete(DeleteBehavior.Restrict);


        modelBuilder.Entity<Product>()
            .HasMany(p => p.Likes)
            .WithOne(l => l.Product)
            .HasForeignKey(l => l.ProductId)
            .OnDelete(DeleteBehavior.NoAction);

        modelBuilder.Entity<Comment>()
              .HasOne(c => c.Product)
              .WithMany(p => p.Comments)
              .HasForeignKey(c => c.ProductId)
              .OnDelete(DeleteBehavior.NoAction);


    }
}