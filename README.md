# hmc5883l
hmc5883l电子罗盘  自测, 校准，例子


## 自测试 (确认焊接是否正常，模块是否正常)
```shell
	
	sudo python hmc5883l.py test_self_test
	""" 输出:
	(86, -163, -44)
	self test pass!
	x:471,y:450,z:458---gain:5  243<val<575
	"""
```

## 椭圆拟合校准

```shell
	
	#步骤1: 运行数据记录
	sudo python hmc5883l.py test_plot>1.plot
	#步骤2: 水平旋转模块两周 使收集多组不同的数据
	#步骤3: 简单产生matlab需要的数据
	cat 1.plot | awk 'BEGIN{res="["}{res=res $1" "$2";";}END{res=res"]";print res}'
	#步骤4: 设置matlab当前工作目录 为 tools/HMC5883拟合椭圆
	#步骤5: matlab 输入 XY = [x y, x1, y1, x2 y2, ...]，运行;      其中XY=后面粘贴步骤三产生的数据
	#步骤6: matlab hmc5883，运行 ，产生四个数据xc yc a b
	
```

程序中使用校准参数

	```python
	def fix(x,y):
		x=x-xc 
		y=y-yc
		if b>a: 
	   		y=y*(b/a)
		else:
	   		y=y*(a/b) 
			
		return x,y
	```

## 运行
```shell
	
	sudo python compass.py
	""" 输出:
	deg:51.570597941, deg_str:北偏东 38.0°26.0′

	"""
```