#!/bin/bash

echo "🔍 NeonFocus 快速验证脚本"
echo "================================"
echo ""

echo "1️⃣ 检查 Flutter 环境..."
flutter --version | head -1
echo ""

echo "2️⃣ 运行代码分析..."
flutter analyze 2>&1 | tail -5
echo ""

echo "3️⃣ 检查关键文件..."
files=(
    "lib/features/stopwatch/presentation/screens/stopwatch_settings_screen.dart"
    "lib/core/services/charging_service.dart"
    "test/widget_test.dart"
    "assets/images/.gitkeep"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file"
    else
        echo "❌ $file (缺失)"
    fi
done
echo ""

echo "4️⃣ 统计代码行数..."
echo "Dart 文件数量: $(find lib -name "*.dart" | wc -l)"
echo "总代码行数: $(find lib -name "*.dart" -exec wc -l {} + | tail -1 | awk '{print $1}')"
echo ""

echo "5️⃣ 检查依赖..."
flutter pub get > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ 依赖安装成功"
else
    echo "❌ 依赖安装失败"
fi
echo ""

echo "================================"
echo "✅ 验证完成！"
echo ""
echo "下一步："
echo "  • 运行应用: flutter run"
echo "  • 运行测试: flutter test"
echo "  • 查看文档: cat FIXES_SUMMARY.md"
