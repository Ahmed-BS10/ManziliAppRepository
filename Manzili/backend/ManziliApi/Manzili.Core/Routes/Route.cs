using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Manzili.Core.Routes
{
    public static class Route
    {
        public const string root = "Api";
        public const string version = "V1";
        public const string Rule = $"{root}/{version}/";

        public static class UserRouting
        {
            public const string Prefix = $"{Rule}User/";
            public const string List = $"{Prefix}List";
            public const string GetById = $"{Prefix}{"Id"}";
            public const string Create = $"{Prefix}Create";
            public const string Edit = $"{Prefix}Edit";
            public const string Delete = $"{Prefix}Delete{"Id"}";

        }

        public static class StoreRouting
        {
            public const string Prefix = $"{Rule}Store/";
            public const string List = $"{Prefix}List";
            public const string GetById = $"{Prefix}{"Id"}";
            public const string Create = $"{Prefix}Create";
            public const string Edit = $"{Prefix}Edit";
            public const string Delete = $"{Prefix}Delete{"Id"}";

        }


        public static class AuthenticationRouting
        {
            public const string Prefix = $"{Rule}Authentication/";
            public const string RegsiterUser = $"{Prefix}RegsiterUser";
            public const string RegsiterStore = $"{Prefix}RegsiterStore";
            public const string Login = $"{Prefix}Login";
            public const string Logout = $"{Prefix}Logout{"Id"}";

        }
        public static class RoleRouting
        {
            public const string Prefix = $"{Rule}Role/";
            public const string List = $"{Prefix}List";
            public const string Create = $"{Prefix}Create";
            public const string Edit = $"{Prefix}Edit";
            public const string Delete = $"{Prefix}Delete{"Id"}";

        }
        public static class AuthorizationRouting
        {
            public const string Prefix = $"{Rule}Authorization/";
            public const string Add = $"{Prefix}AddUserRole";
            public const string Edit = $"{Prefix}Edit";
            public const string Delete = $"{Prefix}DeleteUserRole{"Id"}";

        }
        public static class ActiveRouting
        {
            public const string Prefix = $"{Rule}Active/";
            public const string List = $"{Prefix}List";
            public const string Get = $"{Prefix}GetBy{"Slug"}";
            public const string Create = $"{Prefix}Create";
            public const string Edit = $"{Prefix}Edit";
            public const string Delete = $"{Prefix}Delete{"Slug"}";
            public const string GetListWithincludes = $"{Prefix}GetListWithincludes";

        }
        public static class PaymentRouting
        {
            public const string Prefix = $"{Rule}Paymnet/";
            public const string List = $"{Prefix}List";
            public const string GetBySlug = $"{Prefix}GetBy{"Slug"}";
            public const string Create = $"{Prefix}Create";
            public const string Edit = $"{Prefix}Edit";
            public const string Delete = $"{Prefix}Delete{"Id"}";
            public const string GetListWithincludes = $"{Prefix}GetListWithincludes";

        }
        public static class EmployeRouting
        {
            public const string Prefix = $"{Rule}Employe/";
            public const string List = $"{Prefix}List";
            public const string GetBySlug = $"{Prefix}GetBy{"Slug"}";
            public const string Create = $"{Prefix}Create";
            public const string Edit = $"{Prefix}Edit";
            public const string Delete = $"{Prefix}Delete{"Id"}";
            public const string GetListWithincludes = $"{Prefix}GetListWithincludes";

        }
        public static class FileRouting
        {
            public const string Prefix = $"{Rule}File/";
            public const string List = $"{Prefix}List";
            public const string GetBySlug = $"{Prefix}GetBy{"Slug"}";
            public const string Create = $"{Prefix}Create";
            public const string Edit = $"{Prefix}Edit";
            public const string Delete = $"{Prefix}Delete{"Id"}";
            public const string GetListWithincludes = $"{Prefix}GetListWithincludes";

        }


        public static class FileOutsiedRouting
        {
            public const string Prefix = $"{Rule}FileOutsied/";
            public const string List = $"{Prefix}List";
            public const string GetById = $"{Prefix}Get{"Id"}";
            public const string Create = $"{Prefix}Create";
            public const string Edit = $"{Prefix}Edit";
            public const string Delete = $"{Prefix}Delete{"Id"}";
            public const string GetListWithincludes = $"{Prefix}GetListWithincludes";

        }

        public static class ArchiveRouting
        {
            public const string Prefix = $"{Rule} Archive/";
            public const string List = $"{Prefix}List";
            public const string GetBySlug = $"{Prefix}Get{"Slug"}";
            public const string Create = $"{Prefix}Create";
            public const string Edit = $"{Prefix}Edit";
            public const string Delete = $"{Prefix}Delete{"Id"}";
            public const string GetListWithincludes = $"{Prefix}GetListWithincludes";

        }
    }
}
