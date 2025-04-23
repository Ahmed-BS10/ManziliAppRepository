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
    public DbSet<Product> Products { get; set; }

    public DbSet<Image> Images { get; set; }
    public DbSet<ProductCategory> ProductCategories { get; set; }
    public DbSet<StoreCategoryStore> StoreCategoryStores { get; set; }
    public DbSet<StoreCategory> StoreCategories { get; set; }
    public DbSet<StoreRating> StoreRatings { get; set; }
    public DbSet<Favorite> Favorites { get; set; }
    public DbSet<Comment> Comments { get; set; } 
    public DbSet<ProductRating> ProductRatings { get; set; } 
    public DbSet<Cart> Carts { get; set; }
    public DbSet<CartProduct> CartProducts { get; set; }
    public DbSet<Order> Orders { get; set; }
    public DbSet<OrderProduct> OrderProducts { get; set; }  





    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);


        modelBuilder.Entity<User>().ToTable("Users");
        modelBuilder.Entity<Store>().ToTable("Stores");



        // StoreCategoriesStores With Store , StoreCategory

        modelBuilder.Entity<Store>()
            .HasMany(s => s.storeCategoryStores)
            .WithOne(sc => sc.Store)
            .HasForeignKey(sc => sc.StoreId);



        modelBuilder.Entity<StoreCategory>()
           .HasMany(s => s.StoreCategoriesStores)
           .WithOne(sc => sc.StoreCategory)
           .HasForeignKey(sc => sc.StoreCategoryId);


        // StoreRating With User , Store

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



        // Favorite With User , Store

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



        // Store With Product
        modelBuilder.Entity<Store>()
            .HasMany(s => s.Products)
            .WithOne(p => p.Store)
            .HasForeignKey(p => p.StoreId)
            .OnDelete(DeleteBehavior.NoAction);

        // Product with ProductCategory  
        modelBuilder.Entity<ProductCategory>()
            .HasMany(pc => pc.Products)
            .WithOne(p => p.ProductCategory)
            .HasForeignKey(p => p.ProductCategoryId)
            .OnDelete(DeleteBehavior.NoAction);



        // StoreCategory with ProdctCategory
        modelBuilder.Entity<StoreCategory>()
            .HasMany(x => x.ProductCategories)
            .WithOne(s => s.StoreCategory)
            .HasForeignKey(x => x.StoreCategoryId)
            .OnDelete(DeleteBehavior.NoAction);


        modelBuilder.Entity<Cart>()
                .HasOne(c => c.User)
                .WithMany(u => u.Carts)
                .HasForeignKey(c => c.UserId)
                .OnDelete(DeleteBehavior.NoAction);

        modelBuilder.Entity<Cart>()
            .HasOne(c => c.Store)
            .WithOne()
            .HasForeignKey<Cart>(c => c.StoreId)
            .OnDelete(DeleteBehavior.NoAction);

        modelBuilder.Entity<Product>()
            .HasMany(p => p.CartProducts)
            .WithOne(c => c.Product)
            .HasForeignKey(p => p.ProductId)
            .OnDelete(DeleteBehavior.NoAction);


        modelBuilder.Entity<Cart>()
          .HasMany(p => p.CartProducts)
          .WithOne(c => c.Cart)
          .HasForeignKey(p => p.CartId)
          .OnDelete(DeleteBehavior.NoAction);


        modelBuilder.Entity<User>()
            .HasMany(c => c.Carts)
            .WithOne(u => u.User)
            .HasForeignKey(fk => fk.UserId);



        modelBuilder.Entity<Store>()
         .HasMany(c => c.StoreCarts)
         .WithOne(u => u.Store)
         .HasForeignKey(fk => fk.StoreId);




        modelBuilder.Entity<Order>()
            .HasMany(op => op.OrderProducts)
            .WithOne(o => o.Order)
            .HasForeignKey(fk => fk.OrderId)
            .OnDelete(DeleteBehavior.NoAction);



        modelBuilder.Entity<OrderProduct>()
        .HasOne(op => op.Product)
        .WithMany(p => p.OrderProducts)
        .HasForeignKey(op => op.ProductId)
        .OnDelete(DeleteBehavior.NoAction);

        modelBuilder.Entity<Store>()
            .HasMany(o => o.StoreOrders)
            .WithOne(s => s.Store)
            .HasForeignKey(fk => fk.StoreId)
            .OnDelete(DeleteBehavior.NoAction);



        modelBuilder.Entity<User>()
           .HasMany(o => o.Orders)
           .WithOne(s => s.User)
           .HasForeignKey(fk => fk.UserId)
           .OnDelete(DeleteBehavior.NoAction);




        //modelBuilder.Entity<StoreCategory>().HasData(
        //           new StoreCategory { Id = 1, Name = "الإلكترونيات" },
        //           new StoreCategory { Id = 2, Name = "الملابس" },
        //           new StoreCategory { Id = 3, Name = "الأثاث المنزلي" }
        //       );


        //modelBuilder.Entity<Product>().HasData(

        //     new Product
        //     {
        //         Id = 1,
        //         Name = "قميص رجالي",
        //         Price = 199.99,
        //         Description = "قميص قطني عالي الجودة",
        //         Quantity = 50,
        //         Discount = 10,
        //         ProductCategoryId = 1,
        //         StoreId = 6
        //     },
        //        new Product
        //        {
        //            Id = 2,
        //            Name = "هاتف ذكي",
        //            Price = 5999.99,
        //            Description = "أحدث هاتف ذكي بمواصفات عالية",
        //            Quantity = 20,
        //            ProductCategoryId = 3,
        //            StoreId = 7
        //        },
        //        new Product
        //        {
        //            Id = 3,
        //            Name = "كنبة",
        //            Price = 3499.99,
        //            Description = "كنبة فخمة من الجلد الطبيعي",
        //            Quantity = 10,
        //            Discount = 15,
        //            ProductCategoryId = 5,
        //            StoreId = 8
        //        },
        //        new Product
        //        {
        //            Id = 10,
        //            Name = "رواية",
        //            Price = 99.99,
        //            Description = "أحدث الروايات العربية",
        //            Quantity = 100,
        //            ProductCategoryId = 5,
        //            StoreId = 9
        //        },
        //        new Product
        //        {
        //            Id = 4,
        //            Name = "عسل طبيعي",
        //            Price = 149.99,
        //            Description = "عسل نحل طبيعي 100%",
        //            Quantity = 30,
        //            Discount = 5,
        //            ProductCategoryId = 5,
        //            StoreId = 10
        //        },
        //        new Product
        //        {
        //            Id = 5,
        //            Name = "بنطال جينز",
        //            Price = 299.99,
        //            Description = "بنطال جينز رجالي مقاوم للتجاعيد",
        //            Quantity = 40,
        //            ProductCategoryId = 1,
        //            StoreId = 6
        //        },
        //        new Product
        //        { Id = 6,
        //            Name = "لابتوب",
        //            Price = 12999.99,
        //            Description = "لابتوب بمواصفات عالية للألعاب",
        //            Quantity = 15,
        //            Discount = 20,
        //            ProductCategoryId = 4,
        //            StoreId = 7
        //        },
        //        new Product
        //        {
        //            Id = 7,
        //            Name = "طاولة طعام",
        //            Price = 2499.99,
        //            Description = "طاولة طعام خشبية لـ 6 أشخاص",
        //            Quantity = 8,
        //            ProductCategoryId = 5,
        //            StoreId = 8
        //        },
        //        new Product
        //        {
        //            Id = 8,
        //            Name = "كتاب طبخ",
        //            Price = 149.99,
        //            Description = "كتاب يحتوي على وصفات من المطبخ العربي",
        //            Quantity = 25,
        //            ProductCategoryId = 5,
        //            StoreId = 9
        //        },
        //        new Product
        //        {
        //            Id = 9,
        //            Name = "تمر",
        //            Price = 89.99,
        //            Description = "تمر مجدول عالي الجودة",
        //            Quantity = 60,
        //            ProductCategoryId = 5,
        //            StoreId = 10
        //        }
        //        );
            

            
      


        //// بيانات فئات المنتجات
        //modelBuilder.Entity<ProductCategory>().HasData(
        //    new ProductCategory { Id = 1, Name = "هواتف ذكية", Image = "smartphones.jpg", StoreCategoryId = 1 },
        //    new ProductCategory { Id = 2, Name = "لابتوبات", Image = "laptops.jpg", StoreCategoryId = 1 },
        //    new ProductCategory { Id = 3, Name = "ملابس رجالية", Image = "mens-clothing.jpg", StoreCategoryId = 2 },
        //    new ProductCategory { Id = 4, Name = "ملابس نسائية", Image = "womens-clothing.jpg", StoreCategoryId = 2 },
        //    new ProductCategory { Id = 5, Name = "أرائك", Image = "sofas.jpg", StoreCategoryId = 3 },
        //    new ProductCategory { Id = 6, Name = "طاولات", Image = "tables.jpg", StoreCategoryId = 3 }


        //);
    }

}



public static class SeedData
{
    public static void Initialize(ManziliDbContext context)
    {
        // Ensure the database is created
        context.Database.EnsureCreated();

        // Add Store Categories
        if (!context.StoreCategories.Any())
        {
            var storeCategories = new List<StoreCategory>
            {
                new StoreCategory { Name = "ملابس", Image = "clothing.jpg" },
                new StoreCategory { Name = "إلكترونيات", Image = "electronics.jpg" },
                new StoreCategory { Name = "أثاث", Image = "furniture.jpg" },
                new StoreCategory { Name = "أطعمة", Image = "food.jpg" },
                new StoreCategory { Name = "كتب", Image = "books.jpg" }
            };
            context.StoreCategories.AddRange(storeCategories);
            context.SaveChanges();
        }

        // Add Product Categories
        if (!context.ProductCategories.Any())
        {
            var productCategories = new List<ProductCategory>
            {
                new ProductCategory { Name = "رجالي", StoreCategoryId = 1, Image = "men_clothing.jpg" },
                new ProductCategory { Name = "نسائي", StoreCategoryId = 1, Image = "women_clothing.jpg" },
                new ProductCategory { Name = "هواتف", StoreCategoryId = 2, Image = "phones.jpg" },
                new ProductCategory { Name = "حواسيب", StoreCategoryId = 2, Image = "computers.jpg" },
                new ProductCategory { Name = "أثاث منزلي", StoreCategoryId = 3, Image = "home_furniture.jpg" }
            };
            context.ProductCategories.AddRange(productCategories);
            context.SaveChanges();
        }

        // Add Users (Customers)
        if (!context.Users.OfType<User>().Any(u => u.FavoritesStore == null))
        {
            var users = new List<User>
            {
                new User { UserName = "ahmed", Email = "ahmed@example.com", Address = "القاهرة، مصر", ImageUrl = "user1.jpg" },
                new User { UserName = "mohamed", Email = "mohamed@example.com", Address = "الإسكندرية، مصر", ImageUrl = "user2.jpg" },
                new User { UserName = "fatima", Email = "fatima@example.com", Address = "الجيزة، مصر", ImageUrl = "user3.jpg" },
                new User { UserName = "ali", Email = "ali@example.com", Address = "المنصورة، مصر", ImageUrl = "user4.jpg" },
                new User { UserName = "sara", Email = "sara@example.com", Address = "أسوان، مصر", ImageUrl = "user5.jpg" }
            };
            context.Users.AddRange(users);
            context.SaveChanges();
        }

        // Add Stores
        if (!context.Users.OfType<Store>().Any())
        {
            var stores = new List<Store>
            {
                new Store {
                    UserName = "store1",
                    Email = "store1@example.com",
                    Address = "القاهرة، مصر",
                    BusinessName = "متجر الأزياء الرجالية",
                    Description = "أفضل الملابس الرجالية في مصر",
                    BankAccount = "EG123456789",
                    BookTime = "9 صباحاً - 10 مساءً",
                    SocileMediaAcount = "facebook.com/store1",
                    Rate = 4.5
                },
                new Store {
                    UserName = "store2",
                    Email = "store2@example.com",
                    Address = "الإسكندرية، مصر",
                    BusinessName = "متجر الإلكترونيات",
                    Description = "أحدث الأجهزة الإلكترونية بأسعار تنافسية",
                    BankAccount = "EG987654321",
                    BookTime = "10 صباحاً - 11 مساءً",
                    SocileMediaAcount = "facebook.com/store2",
                    Rate = 4.2
                },
                new Store {
                    UserName = "store3",
                    Email = "store3@example.com",
                    Address = "الجيزة، مصر",
                    BusinessName = "أثاث المنزل",
                    Description = "أجود أنواع الأثاث المنزلي",
                    BankAccount = "EG456789123",
                    BookTime = "8 صباحاً - 9 مساءً",
                    Rate = 4.0
                },
                new Store {
                    UserName = "store4",
                    Email = "store4@example.com",
                    Address = "المنصورة، مصر",
                    BusinessName = "كتب ومجلات",
                    Description = "أكبر تشكيلة من الكتب العربية والأجنبية",
                    BankAccount = "EG789123456",
                    BookTime = "9 صباحاً - 8 مساءً",
                    SocileMediaAcount = "facebook.com/store4",
                    Rate = 4.7
                },
                new Store {
                    UserName = "store5",
                    Email = "store5@example.com",
                    Address = "أسوان، مصر",
                    BusinessName = "الأطعمة العضوية",
                    Description = "منتجات عضوية طازجة من المزرعة إلى منزلك",
                    BankAccount = "EG321654987",
                    BookTime = "7 صباحاً - 10 مساءً",
                    Rate = 4.8
                }
            };
            context.Users.AddRange(stores);
            context.SaveChanges();

            // Add StoreCategoryStore relationships
            var storeCategoryStores = new List<StoreCategoryStore>
            {
                new StoreCategoryStore { StoreId = 6, StoreCategoryId = 1 }, // متجر الأزياء الرجالية - ملابس
                new StoreCategoryStore { StoreId = 7, StoreCategoryId = 2 }, // متجر الإلكترونيات - إلكترونيات
                new StoreCategoryStore { StoreId = 8, StoreCategoryId = 3 }, // أثاث المنزل - أثاث
                new StoreCategoryStore { StoreId = 9, StoreCategoryId = 5 }, // كتب ومجلات - كتب
                new StoreCategoryStore { StoreId = 10, StoreCategoryId = 4 } // الأطعمة العضوية - أطعمة
            };
            context.StoreCategoryStores.AddRange(storeCategoryStores);
            context.SaveChanges();
        }

        // Add Products
        if (!context.Products.Any())
        {
           

            // Add Product Images
            var images = new List<Image>
            {
                new Image { ImageUrl = "shirt1.jpg", ProductId = 1 },
                new Image { ImageUrl = "shirt2.jpg", ProductId = 1 },
                new Image { ImageUrl = "phone1.jpg", ProductId = 2 },
                new Image { ImageUrl = "sofa1.jpg", ProductId = 3 },
                new Image { ImageUrl = "sofa2.jpg", ProductId = 3 },
                new Image { ImageUrl = "book1.jpg", ProductId = 4 },
                new Image { ImageUrl = "honey1.jpg", ProductId = 5 },
                new Image { ImageUrl = "jeans1.jpg", ProductId = 6 },
                new Image { ImageUrl = "laptop1.jpg", ProductId = 7 },
                new Image { ImageUrl = "table1.jpg", ProductId = 8 }
            };
            context.Images.AddRange(images);
            context.SaveChanges();
        }

        //// Add Favorites
        //if (!context.Favorites.Any())
        //{
        //    var favorites = new List<Favorite>
        //    {
        //        new Favorite { UserId = 1, StoreId = 6 },
        //        new Favorite { UserId = 1, StoreId = 7 },
        //        new Favorite { UserId = 2, StoreId = 8 },
        //        new Favorite { UserId = 3, StoreId = 9 },
        //        new Favorite { UserId = 4, StoreId = 10 }
        //    };
        //    context.Favorites.AddRange(favorites);
        //    context.SaveChanges();
        //}

        //// Add Ratings
        //if (!context.StoreRatings.Any())
        //{
        //    var ratings = new List<StoreRating>
        //    {
        //        new StoreRating { UserId = 1, StoreId = 6, RatingValue = 5 },
        //        new StoreRating { UserId = 2, StoreId = 6, Rating = 4},
        //        new StoreRating { UserId = 3, StoreId = 7, Rating = 5, Comment = "أفضل متجر إلكترونيات" },
        //        new StoreRating { UserId = 4, StoreId = 8, Rating = 4, Comment = "أثاث عالي الجودة" },
        //        new StoreRating { UserId = 5, StoreId = 9, Rating = 5, Comment = "تشكيلة كتب ممتازة" }
        //    };
        //    context.StoreRatings.AddRange(ratings);
        //    context.SaveChanges();
        //}
    }
}



//protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
//{
//    base.OnConfiguring(optionsBuilder);

//    optionsBuilder.UseSqlServer("Server=db13966.Public.databaseasp.net; Database=db13966; User Id=db13966; Password=4Rb#X+6og2L_; Encrypt=False; MultipleActiveResultSets=True;")
//        .LogTo(Console.WriteLine, Microsoft.Extensions.Logging.LogLevel.Information);


//}













//protected override void OnModelCreating(ModelBuilder modelBuilder)
//    {
//        base.OnModelCreating(modelBuilder);

//        // تهيئة البيانات هنا
//        SeedData(modelBuilder);
//    }

//private void SeedData(ModelBuilder modelBuilder)
//{
//    // Store Categories
//    modelBuilder.Entity<StoreCategory>().HasData(
//        new StoreCategory { Id = 1, Name = "ملابس", Image = "clothing.jpg" },
//        new StoreCategory { Id = 2, Name = "إلكترونيات", Image = "electronics.jpg" },
//        new StoreCategory { Id = 3, Name = "أثاث", Image = "furniture.jpg" },
//        new StoreCategory { Id = 4, Name = "أطعمة", Image = "food.jpg" },
//        new StoreCategory { Id = 5, Name = "كتب", Image = "books.jpg" }
//    );

//    // Product Categories
//    modelBuilder.Entity<ProductCategory>().HasData(
//        new ProductCategory { Id = 1, Name = "رجالي", StoreCategoryId = 1, Image = "men_clothing.jpg" },
//        new ProductCategory { Id = 2, Name = "نسائي", StoreCategoryId = 1, Image = "women_clothing.jpg" },
//        new ProductCategory { Id = 3, Name = "هواتف", StoreCategoryId = 2, Image = "phones.jpg" },
//        new ProductCategory { Id = 4, Name = "حواسيب", StoreCategoryId = 2, Image = "computers.jpg" },
//        new ProductCategory { Id = 5, Name = "أثاث منزلي", StoreCategoryId = 3, Image = "home_furniture.jpg" }
//    );

//    // Users (Customers)
//    modelBuilder.Entity<User>().HasData(
//        new User { Id = 1, UserName = "ahmed", Email = "ahmed@example.com", Address = "القاهرة، مصر", ImageUrl = "user1.jpg" },
//        new User { Id = 2, UserName = "mohamed", Email = "mohamed@example.com", Address = "الإسكندرية، مصر", ImageUrl = "user2.jpg" },
//        new User { Id = 3, UserName = "fatima", Email = "fatima@example.com", Address = "الجيزة، مصر", ImageUrl = "user3.jpg" },
//        new User { Id = 4, UserName = "ali", Email = "ali@example.com", Address = "المنصورة، مصر", ImageUrl = "user4.jpg" },
//        new User { Id = 5, UserName = "sara", Email = "sara@example.com", Address = "أسوان، مصر", ImageUrl = "user5.jpg" }
//    );

//    // Stores
//    modelBuilder.Entity<Store>().HasData(
//        new Store
//        {
//            Id = 6,
//            UserName = "store1",
//            Email = "store1@example.com",
//            Address = "القاهرة، مصر",
//            BusinessName = "متجر الأزياء الرجالية",
//            Description = "أفضل الملابس الرجالية في مصر",
//            BankAccount = "EG123456789",
//            BookTime = "9 صباحاً - 10 مساءً",
//            SocileMediaAcount = "facebook.com/store1",
//            Rate = 4.5
//        },
//        new Store
//        {
//            Id = 7,
//            UserName = "store2",
//            Email = "store2@example.com",
//            Address = "الإسكندرية، مصر",
//            BusinessName = "متجر الإلكترونيات",
//            Description = "أحدث الأجهزة الإلكترونية بأسعار تنافسية",
//            BankAccount = "EG987654321",
//            BookTime = "10 صباحاً - 11 مساءً",
//            SocileMediaAcount = "facebook.com/store2",
//            Rate = 4.2
//        },
//        new Store
//        {
//            Id = 8,
//            UserName = "store3",
//            Email = "store3@example.com",
//            Address = "الجيزة، مصر",
//            BusinessName = "أثاث المنزل",
//            Description = "أجود أنواع الأثاث المنزلي",
//            BankAccount = "EG456789123",
//            BookTime = "8 صباحاً - 9 مساءً",
//            Rate = 4.0
//        },
//        new Store
//        {
//            Id = 9,
//            UserName = "store4",
//            Email = "store4@example.com",
//            Address = "المنصورة، مصر",
//            BusinessName = "كتب ومجلات",
//            Description = "أكبر تشكيلة من الكتب العربية والأجنبية",
//            BankAccount = "EG789123456",
//            BookTime = "9 صباحاً - 8 مساءً",
//            SocileMediaAcount = "facebook.com/store4",
//            Rate = 4.7
//        },
//        new Store
//        {
//            Id = 10,
//            UserName = "store5",
//            Email = "store5@example.com",
//            Address = "أسوان، مصر",
//            BusinessName = "الأطعمة العضوية",
//            Description = "منتجات عضوية طازجة من المزرعة إلى منزلك",
//            BankAccount = "EG321654987",
//            BookTime = "7 صباحاً - 10 مساءً",
//            Rate = 4.8
//        }
//    );

//    // StoreCategoryStore relationships
//    modelBuilder.Entity<StoreCategoryStore>().HasData(
//        new StoreCategoryStore { Id = 1, StoreId = 6, StoreCategoryId = 1 },
//        new StoreCategoryStore { Id = 2, StoreId = 7, StoreCategoryId = 2 },
//        new StoreCategoryStore { Id = 3, StoreId = 8, StoreCategoryId = 3 },
//        new StoreCategoryStore { Id = 4, StoreId = 9, StoreCategoryId = 5 },
//        new StoreCategoryStore { Id = 5, StoreId = 10, StoreCategoryId = 4 }
//    );

//    // Products
//    modelBuilder.Entity<Product>().HasData(
//        new Product
//        {
//            Id = 1,
//            Name = "قميص رجالي",
//            Price = 199.99,
//            Description = "قميص قطني عالي الجودة",
//            Quantity = 50,
//            Discount = 10,
//            ProductCategoryId = 1,
//            StoreId = 6
//        },
//        new Product
//        {
//            Id = 2,
//            Name = "هاتف ذكي",
//            Price = 5999.99,
//            Description = "أحدث هاتف ذكي بمواصفات عالية",
//            Quantity = 20,
//            ProductCategoryId = 3,
//            StoreId = 7
//        },
//        new Product
//        {
//            Id = 3,
//            Name = "كنبة",
//            Price = 3499.99,
//            Description = "كنبة فخمة من الجلد الطبيعي",
//            Quantity = 10,
//            Discount = 15,
//            ProductCategoryId = 5,
//            StoreId = 8
//        },
//        new Product
//        {
//            Id = 4,
//            Name = "رواية",
//            Price = 99.99,
//            Description = "أحدث الروايات العربية",
//            Quantity = 100,
//            ProductCategoryId = 5,
//            StoreId = 9
//        },
//        new Product
//        {
//            Id = 5,
//            Name = "عسل طبيعي",
//            Price = 149.99,
//            Description = "عسل نحل طبيعي 100%",
//            Quantity = 30,
//            Discount = 5,
//            ProductCategoryId = 5,
//            StoreId = 10
//        }
//    );

//    // Product Images
//    modelBuilder.Entity<Image>().HasData(
//        new Image { Id = 1, ImageUrl = "shirt1.jpg", ProductId = 1 },
//        new Image { Id = 2, ImageUrl = "shirt2.jpg", ProductId = 1 },
//        new Image { Id = 3, ImageUrl = "phone1.jpg", ProductId = 2 },
//        new Image { Id = 4, ImageUrl = "sofa1.jpg", ProductId = 3 },
//        new Image { Id = 5, ImageUrl = "sofa2.jpg", ProductId = 3 },
//        new Image { Id = 6, ImageUrl = "book1.jpg", ProductId = 4 },
//        new Image { Id = 7, ImageUrl = "honey1.jpg", ProductId = 5 }
//    );
//}