namespace Manzili.Core.Routes
{
    public static class Route
    {
        //public const string root = "Api";
        //public const string version = "V1";
        //public const string Rule = $"{root}/{version}/";

        public static class UserRouting
        {
            public const string List = "List";
            public const string GetById = $"{"Id"}";
            public const string Create = "Create";
            public const string Edit = "Edit";
            public const string Delete = $"Delete";

        }


        public static class CategoryRouting
        {
            public const string List = "List";
            public const string GetById = $"{"Id"}";
            public const string Create = "Create";
            public const string Update = $"Edit{"Id"}";
            public const string Delete = $"Delete";

        }

        public static class StoreRouting
        {
            public const string Prefix = $"Store/";
            public const string List = $"List";
            public const string GetById = $"{"Id"}";
            public const string Create = $"Create";
            public const string Edit = $"Edit";
            public const string Delete = $"Delete";

        }


        public static class AuthenticationRouting
        {
            public const string Prefix = $"Authentication/";
            public const string RegsiterUser = $"RegsiterUser";
            public const string RegsiterStore = $"RegsiterStore";
            public const string Login = $"Login";
            public const string Logout = $"Logout";

        }
        public static class RoleRouting
        {
            public const string Prefix = $"Role/";
            public const string List = $"List";
            public const string Create = $"Create";
            public const string Edit = $"Edit";
            public const string Delete = $"Delete";

        }
        public static class AuthorizationRouting
        {
            public const string Prefix = $"Authorization/";
            public const string Add = $"AddUserRole";
            public const string Edit = $"Edit";
            public const string Delete = $"DeleteUserRole";

        }
        public static class ActiveRouting
        {
            public const string Prefix = $"Active/";
            public const string List = $"List";
            public const string Get = $"GetBy";
            public const string Create = $"Create";
            public const string Edit = $"Edit";
            public const string Delete = $"Delete";
            public const string GetListWithincludes = $"GetListWithincludes";

        }
        public static class PaymentRouting
        {
            public const string Prefix = $"Paymnet/";
            public const string List = $"List";
            public const string GetBySlug = $"GetBy";
            public const string Create = $"Create";
            public const string Edit = $"Edit";
            public const string Delete = $"Delete";
            public const string GetListWithincludes = $"GetListWithincludes";

        }
        public static class EmployeRouting
        {
            public const string Prefix = $"Employe/";
            public const string List = $"List";
            public const string GetBySlug = $"GetBy";
            public const string Create = $"Create";
            public const string Edit = $"Edit";
            public const string Delete = $"Delete";
            public const string GetListWithincludes = $"GetListWithincludes";

        }
        public static class FileRouting
        {
            public const string Prefix = $"File/";
            public const string List = $"List";
            public const string GetBySlug = $"GetBy";
            public const string Create = $"Create";
            public const string Edit = $"Edit";
            public const string Delete = $"Delete";
            public const string GetListWithincludes = $"GetListWithincludes";

        }


        public static class FileOutsiedRouting
        {
            public const string Prefix = $"FileOutsied/";
            public const string List = $"List";
            public const string GetById = $"Get";
            public const string Create = $"Create";
            public const string Edit = $"Edit";
            public const string Delete = $"Delete";
            public const string GetListWithincludes = $"GetListWithincludes";

        }

        public static class ArchiveRouting
        {
            public const string Prefix = $" Archive/";
            public const string List = $"List";
            public const string GetBySlug = $"Get";
            public const string Create = $"Create";
            public const string Edit = $"Edit";
            public const string Delete = $"Delete";
            public const string GetListWithincludes = $"GetListWithincludes";

        }
    }
}
