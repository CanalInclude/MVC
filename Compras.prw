#INCLUDE 'Protheus.ch'
#INCLUDE 'FwMvcDef.ch'

/*/{Protheus.doc} Compras
    Rotina de pedidos de compra customizado em MVC
    @author Leonardo Bilar
    @since 22/02/2024
    /*/
User Function Compras()

    Local oBrowse := FWMBrowse():New()
    Local aRotina := Nil
    
    aRotina := MenuDef()

    oBrowse:SetAlias('Z01')
    oBrowse:SetDescription('Pedidos de Compra - Customizado')

    oBrowse:Activate()

Return

/*/{Protheus.doc} MenuDef
    Menu que será apresentado na tela inicial da rotina (Browse)
    @author Leonardo Bilar
    @since 22/02/2024
    @return aRotina, Array, Array com as opções do menu
    /*/
Static Function MenuDef()

    Local aRotina := {}

    ADD OPTION aRotina TITLE 'Incluir'      ACTION 'VIEWDEF.Compras' OPERATION MODEL_OPERATION_INSERT   ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'VIEWDEF.Compras' OPERATION MODEL_OPERATION_VIEW     ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'      ACTION 'VIEWDEF.Compras' OPERATION MODEL_OPERATION_UPDATE   ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'      ACTION 'VIEWDEF.Compras' OPERATION MODEL_OPERATION_DELETE   ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
    Define o Modelo de dados
    @author Leonardo Bilar
    @since 22/02/2024
    @return oModel, Object, Modelo de dados
    /*/
Static Function ModelDef()

    Local oModel    := Nil

    // Estrutura para os campos das tabela Z01 - Model
    Local oStruZ01  :=  FWFormStruct(1, 'Z01')

    // Estrutura para os campos das tabela Z02 - Model
    Local oStruZ02  :=  FWFormStruct(1, 'Z02')

    // Inicia a criação do Model
    oModel := MPFormModel():New('COMP001')

    // Adiciona ao Model os campos da Z01 em formato Field
    oModel:AddFields('Z01_MASTER', /*cOwner*/, oStruZ01)

    // Adiciona ao Model os campos da Z02 em formato Grid
    oModel:AddGrid('Z02_ITENS', 'Z01_MASTER', oStruZ02)

    // Define o relacionamento entra as tabelas Z02 (filho) e Z01 (pai)
    oModel:SetRelation('Z02_ITENS', {{'Z02_FILIAL', 'xFilial("Z02")'}, {'Z02_COD', 'Z01_COD'}}, Z02->(IndexKey(1)))

    // Define a chave primária
    oModel:SetPrimaryKey({'Z01_FILIAL', 'Z01_COD'})

    // Descrições do Model
    oModel:SetDescription('ModelDescription')
    oModel:GetModel('Z01_MASTER'):SetDescription('ModelMasterDescription')
    oModel:GetModel('Z02_ITENS'):SetDescription('ModelGridDescription')

Return oModel

/*/{Protheus.doc} ViewDef
    Define a View
    @author Leonardo Bilar
    @since 22/02/2024
    @return oView, Object, View para ser exibida ao usuário
    /*/
Static Function ViewDef()

    Local oView     := Nil

    // Recebe o Model para atribuir a View
    Local oModel    := ModelDef()

    // Estrutura para os campos das tabela Z01 - View
    Local oStruZ01  := FWFormStruct(2, 'Z01')

    // Estrutura para os campos das tabela Z02 - View
    Local oStruZ02  := FWFormStruct(2, 'Z02')
    
    // Inicia a criação do Model
    oView := FWFormView():New()

    // Define o model que será utilizado na View
    oView:SetModel(oModel)

    // Adiciona a View os campos definidos no Model Z01_MASTER
    oView:AddField('Z01_VIEW', oStruZ01, 'Z01_MASTER')

    // Adiciona a View os campos definidos no Model Z02_ITENS
    oView:AddGrid('Z02_VIEW', oStruZ02, 'Z02_ITENS')

    // Define um campo da tabela que será preenchido automaticamente de forma incremental
    oView:AddIncrementalField('Z02_VIEW', 'Z02_ITEM')

    // Cria na tela 2 caixas na horizontal sendo 25% para cabeçalho e 75% para o grid de itens
    oView:CreateHorizontalBox('CABEC', 25)
    oView:CreateHorizontalBox('ITENS', 75)

    // Atribui cada view a sua caixa para apresentar os dados na tela
    oView:SetOwnerView('Z01_VIEW', 'CABEC')
    oView:SetOwnerView('Z02_VIEW', 'ITENS')

Return oView
