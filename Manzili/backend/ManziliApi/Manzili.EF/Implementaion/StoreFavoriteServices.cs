﻿using Manzili.Core.Dto.CatagoryDto;
using Manzili.Core.Dto.StoreFavoriteDto;
using Manzili.Core.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.EF.Implementaion
{
    public class StoreFavoriteServices : IStoreFavoriteServices
    {

        #region   Fields
        readonly ManziliDbContext _db;
        readonly DbSet<Favorite> _dbSet;
        #endregion


        #region Constrcutor
        public StoreFavoriteServices(ManziliDbContext db)
        {
            _db = db;
            _dbSet = _db.Set<Favorite>();
        }

        #endregion

        #region Method

        public async Task<OperationResult<CreateStoreFavoriteDto>> Create(CreateStoreFavoriteDto createStoreFavoriteDto)
        {
            if (createStoreFavoriteDto == null)
                return OperationResult<CreateStoreFavoriteDto>.Failure(message: "Favorite cannot be null.");

            var favorite = new Favorite
            {
                UserId = createStoreFavoriteDto.UserId,
                StoreId = createStoreFavoriteDto.StoreId
            };

            await _dbSet.AddAsync(favorite);
            await _db.SaveChangesAsync();
            return OperationResult<CreateStoreFavoriteDto>.Success(createStoreFavoriteDto);
        }




        public async Task<OperationResult<int>> ToggleFavorite(int userId, int storeId)
        {
            // البحث إذا كان العنصر موجودًا بالفعل في المفضلة
            var favorite = await _dbSet.FirstOrDefaultAsync(x => x.UserId == userId && x.StoreId == storeId);

            if (favorite != null)
            {
                // إذا كان موجوداً، نقوم بحذفه
                _dbSet.Remove(favorite);
                await _db.SaveChangesAsync();
                return OperationResult<int>.Success(userId, "تم حذف المفضلة");
            }
            else
            {
                // إذا لم يكن موجوداً، نقوم بإضافته
                favorite = new Favorite
                {
                    UserId = userId,
                    StoreId = storeId
                };
                await _dbSet.AddAsync(favorite);
                await _db.SaveChangesAsync();
                return OperationResult<int>.Success(userId, "تم إضافة المفضلة");
            }
        }


        public async Task<OperationResult<int>> Create(int userId , int storeId)
        {
           

            var favorite = new Favorite
            {
                UserId =  userId,
                StoreId = storeId
            };

            await _dbSet.AddAsync(favorite);
            await _db.SaveChangesAsync();
            return OperationResult<int>.Success(userId);
        }

        public async Task<OperationResult<bool>> Delete(int id)
        {
            if (id <= 0)
                return OperationResult<bool>.Failure(message: "Id cannot be null.");

            var favorite = await _dbSet.FindAsync(id);
            if (favorite == null)
                return OperationResult<bool>.Failure(message: "Favorite not found.");

            _dbSet.Remove(favorite);
            await _db.SaveChangesAsync();
            return OperationResult<bool>.Success(true);

        }

        #endregion




    }
}
