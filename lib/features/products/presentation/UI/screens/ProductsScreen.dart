import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:ribhi/core/AppColor/appcolor.dart';
import 'package:ribhi/core/constant/text.dart';
import 'package:ribhi/core/theme/app_responsive.dart';
import 'package:ribhi/features/Expenses/domain/repo/ExpensesRepo.dart';
import 'package:ribhi/features/Expenses/presentation/cubit/expenses_cubit.dart';
import 'package:ribhi/features/Expenses/presentation/ui/screens/ExpensesScreen.dart';
import 'package:ribhi/features/products/data/datasources/ProductLocalData.dart';
import 'package:ribhi/features/products/data/repo/ProductRepoImplment.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/products_cubit.dart';
import 'package:ribhi/features/products/presentation/Statemanegemnt/products_state.dart';
import 'package:ribhi/features/products/presentation/UI/screens/productsformScreen.dart';
import 'package:ribhi/features/products/presentation/UI/widgets/ProductScreenBody.dart';
import 'package:ribhi/features/reports/data/repo/ReportRepoImpl.dart';
import 'package:ribhi/features/reports/presentation/manager/cubit/reports_cubit.dart';
import 'package:ribhi/features/reports/presentation/ui/screens/ReportsScreen.dart';
import 'package:ribhi/features/sales/data/repo/SaleRepoImpl.dart';
import 'package:ribhi/features/sales/presentation/UI.dart';

class _AppIcons {
  static const home = 'assets/photo/iconamoon_category-light.png';
  static const product = 'assets/photo/fluent-mdl2_product.png';
  static const sales = 'assets/photo/Frame 197 (1).png';
  static const expenses = 'assets/photo/iconoir_wallet.png';
  static const chart = 'assets/photo/carbon_analytics.png';
}

/// ✅ Delete product Dialog
class DeleteDialog extends StatelessWidget {
  final int productId;

  const DeleteDialog({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: s(context, 24)),
      child: Container(
        padding: EdgeInsets.all(s(context, 16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(s(context, 12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Textapp(
              "Are you sure you want to delete?",
              fontWeight: FontWeight.w500,
              fontsize: 16,
            ),
            SizedBox(height: s(context, 16)),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
                SizedBox(width: s(context, 8)),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<ProductsCubit>().deleteProduct(productId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ Edit Category
class EditCategoryDialog extends StatelessWidget {
  final String oldCategory;

  const EditCategoryDialog({super.key, required this.oldCategory});

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    final TextEditingController controller = TextEditingController(
      text: oldCategory,
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: s(context, 24)),
      child: Container(
        padding: EdgeInsets.all(s(context, 16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(s(context, 12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 📝 Title
            Textapp("Edit Category", fontWeight: FontWeight.w600, fontsize: 16),

            SizedBox(height: s(context, 16)),

            /// ✏️ Input
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Enter new category name",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: s(context, 16)),

            /// Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
                SizedBox(width: s(context, 8)),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final newName = controller.text.trim();

                      if (newName.isNotEmpty && newName != oldCategory) {
                        context.read<ProductsCubit>().updateCategory(
                          oldCategory,
                          newName,
                        );
                      }

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ Animation Route
/// delete category
class DeleteCategoryDialog extends StatelessWidget {
  final String category;

  const DeleteCategoryDialog({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: s(context, 24)),
      child: Container(
        padding: EdgeInsets.all(s(context, 16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(s(context, 12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 📝 Text
            Textapp(
              "Are you sure you want to delete '$category'?",
              fontWeight: FontWeight.w500,
              fontsize: 16,
            ),

            SizedBox(height: s(context, 16)),

            /// Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
                SizedBox(width: s(context, 8)),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);

                      context.read<ProductsCubit>().deleteCategory(category);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NavRoute extends PageRouteBuilder {
  _NavRoute({required Widget page})
    : super(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, anim, __, child) {
          final curved = CurvedAnimation(
            parent: anim,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return SlideTransition(
            position: Tween(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(curved),
            child: FadeTransition(opacity: curved, child: child),
          );
        },
      );
}

/// ✅ Main Screen
class ProductsScreen extends StatefulWidget {
  final ExpenseRepository expensesRepository;
  final ReportsRepositoryImpl reportsRepository;
  final ProductRepositoryImpl productsRepository;
  final SaleRepositoryImpl saleRepository;
  final ProductLocalDataSourceImpl productLocalDataSource;

  const ProductsScreen({
    super.key,
    required this.expensesRepository,
    required this.reportsRepository,
    required this.productsRepository,
    required this.saleRepository,
    required this.productLocalDataSource,
  });

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  static const int _activeIndex = 1;

  @override
  void initState() {
    super.initState();
    context.read<ProductsCubit>().loadProducts();
  }

  void _navigateTo(int i) {
    if (i == _activeIndex) return;

    if (i == 0) {
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (i == 2) {
      Navigator.pushReplacement(
        context,
        _NavRoute(
          page: SalesScreen(
            saleRepository: widget.saleRepository,
            productLocalDataSource: widget.productLocalDataSource,
            expensesRepository: widget.expensesRepository,
            reportsRepository: widget.reportsRepository,
            productsRepository: widget.productsRepository,
          ),
        ),
      );
    } else if (i == 3) {
      Navigator.pushReplacement(
        context,
        _NavRoute(
          page: BlocProvider(
            create: (_) =>
                ExpensesCubit(repository: widget.expensesRepository)
                  ..loadExpenses(),
            child: ExpensesScreen(
              expensesRepository: widget.expensesRepository,
              reportsRepository: widget.reportsRepository,
              productsRepository: widget.productsRepository,
              saleRepository: widget.saleRepository,
              productLocalDataSource: widget.productLocalDataSource,
            ),
          ),
        ),
      );
    } else if (i == 4) {
      Navigator.pushReplacement(
        context,
        _NavRoute(
          page: BlocProvider(
            create: (_) => ReportsCubit(repository: widget.reportsRepository),
            child: ReportsScreen(
              reportsRepository: widget.reportsRepository,
              expensesRepository: widget.expensesRepository,
              productsRepository: widget.productsRepository,
              saleRepository: widget.saleRepository,
              productLocalDataSource: widget.productLocalDataSource,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.category,
              color: AppColors.orange,
              size: s(context, 22),
            ),
            onPressed: () => showCategoriesPopup(context),
          ),
        ],
      ),

      /// ➕ Add
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<ProductsCubit>(),
                child: const Productsformscreen(isEdit: false),
              ),
            ),
          );
        },
        child: Icon(Icons.add, size: s(context, 28)),
      ),

      /// 📦 Body
      body: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (context, state) {
          if (state.deleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Deleted successfully')),
            );
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state.isLoading || state.isDeleting,
            child: Productscreenbody(
              onpressed: (int productId) {
                showDialog(
                  context: context,
                  barrierColor: Colors.black.withOpacity(0.4),
                  builder: (_) => DeleteDialog(productId: productId),
                );
              },
            ),
          );
        },
      ),

      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    final s = AppSizes.s;

    final items = [
      [_AppIcons.home, 'Home'],
      [_AppIcons.product, 'Products'],
      [_AppIcons.sales, 'Sales'],
      [_AppIcons.expenses, 'Expenses'],
      [_AppIcons.chart, 'Reports'],
    ];

    return Container(
      padding: EdgeInsets.all(s(context, 12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isActive = i == _activeIndex;
          final color = isActive ? AppColors.orange : AppColors.textSecondary;

          return GestureDetector(
            onTap: () => _navigateTo(i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(items[i][0], width: s(context, 24), color: color),
                if (isActive) Text(items[i][1], style: TextStyle(color: color)),
              ],
            ),
          );
        }),
      ),
    );
  }
}

/// ✅ Categories
void showCategoriesPopup(BuildContext context) {
  final cubit = context.read<ProductsCubit>();
  final categories = cubit.state.categories;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Categories'),
      content: ListView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final category = categories[i];

          return ListTile(
            title: Text(category),

            /// 👇 actions على اليمين
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: SvgPicture.asset("assets/svg/edit.svg"),
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (_) => EditCategoryDialog(oldCategory: category),
                    );
                  },
                ),

                /// 🗑 Delete
                IconButton(
                  icon: SvgPicture.asset("assets/svg/delete.svg"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => DeleteCategoryDialog(category: category),
                    );
                  },
                ),
              ],
            ),

            /// 👇 ضغط عادي = فلترة
            onTap: () {
              cubit.filterByCategory(category);
              Navigator.pop(context);
            },
          );
        },
      ),
    ),
  );
}
