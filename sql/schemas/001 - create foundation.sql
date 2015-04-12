SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

DROP SCHEMA IF EXISTS `metasoft` ;
CREATE SCHEMA IF NOT EXISTS `metasoft` ;
USE `metasoft` ;

-- -----------------------------------------------------
-- Table `metasoft`.`empresa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metasoft`.`empresa` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `cnpj` VARCHAR(30) NULL DEFAULT NULL,
  `nome` VARCHAR(255) NOT NULL,
  `nomeFantasia` VARCHAR(255) NOT NULL,
  `estado` VARCHAR(2) NOT NULL,
  `cidade` VARCHAR(50) NOT NULL,
  `endereco` VARCHAR(255) NOT NULL,
  `cep` VARCHAR(20) NULL,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `metasoft`.`login`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metasoft`.`login` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `login` VARCHAR(20) NOT NULL,
  `senha` VARCHAR(20) NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `papel` VARCHAR(45) NOT NULL,
  `empresaId` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_login_empresa1_idx` (`empresaId` ASC),
  CONSTRAINT `fk_login_empresa1`
    FOREIGN KEY (`empresaId`)
    REFERENCES `metasoft`.`empresa` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `metasoft`.`centroCusto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metasoft`.`centroCusto` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `empresaId` INT UNSIGNED NOT NULL,
  `nome` VARCHAR(128) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_0a92a23a-c6a2-11e4-844e-9439e5f3523b` (`empresaId` ASC),
  CONSTRAINT `fk_0a92a23a-c6a2-11e4-844e-9439e5f3523b`
    FOREIGN KEY (`empresaId`)
    REFERENCES `metasoft`.`empresa` (`id`));


-- -----------------------------------------------------
-- Table `metasoft`.`parceiro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metasoft`.`parceiro` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `empresaId` INT UNSIGNED NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `cliente` TINYINT(1) NOT NULL,
  `fornecedor` TINYINT(1) NOT NULL,
  `email` VARCHAR(45) NULL,
  `telefone` VARCHAR(45) NULL,
  `telefone2` VARCHAR(45) NULL,
  `endereco` VARCHAR(45) NULL,
  `cep` VARCHAR(45) NULL,
  `cnpjCpf` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_0a92f17c-c6a2-11e4-844e-9439e5f3523b` (`empresaId` ASC),
  CONSTRAINT `fk_0a92f17c-c6a2-11e4-844e-9439e5f3523b`
    FOREIGN KEY (`empresaId`)
    REFERENCES `metasoft`.`empresa` (`id`));


-- -----------------------------------------------------
-- Table `metasoft`.`contaBancaria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metasoft`.`contaBancaria` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `empresaId` INT UNSIGNED NOT NULL,
  `saldo` DECIMAL(10,2) NOT NULL,
  `banco` VARCHAR(10) NOT NULL,
  `agencia` VARCHAR(20) NOT NULL,
  `conta` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_0a93275a-c6a2-11e4-844e-9439e5f3523b` (`empresaId` ASC),
  CONSTRAINT `fk_0a93275a-c6a2-11e4-844e-9439e5f3523b`
    FOREIGN KEY (`empresaId`)
    REFERENCES `metasoft`.`empresa` (`id`));


-- -----------------------------------------------------
-- Table `metasoft`.`financeCategory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metasoft`.`financeCategory` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `metasoft`.`metodoPagamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metasoft`.`metodoPagamento` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `empresaId` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_metodoPagamento_empresa1_idx` (`empresaId` ASC),
  CONSTRAINT `fk_metodoPagamento_empresa1`
    FOREIGN KEY (`empresaId`)
    REFERENCES `metasoft`.`empresa` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metasoft`.`conta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metasoft`.`conta` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `empresaId` INT UNSIGNED NOT NULL,
  `loginId` INT UNSIGNED NOT NULL,
  `tipoConta` TINYINT(1) NOT NULL,
  `criadoEm` DATETIME NOT NULL,
  `descricao` VARCHAR(255) NULL DEFAULT NULL,
  `centroCustoId` INT UNSIGNED NOT NULL,
  `metodoPagamentoId` INT UNSIGNED NOT NULL,
  `valorBruto` DECIMAL(10,2) NOT NULL,
  `valorLiquido` DECIMAL(10,2) NOT NULL,
  `parceiroId` INT UNSIGNED NULL,
  `contaBancariaId` INT UNSIGNED NOT NULL,
  `status` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_0a936f08-c6a2-11e4-844e-9439e5f3523b` (`empresaId` ASC),
  INDEX `fk_0a9370d4-c6a2-11e4-844e-9439e5f3523b` (`loginId` ASC),
  INDEX `fk_conta_centroCusto1_idx` (`centroCustoId` ASC),
  INDEX `fk_conta_metodoPagamento1_idx` (`metodoPagamentoId` ASC),
  INDEX `fk_conta_parceiro1_idx` (`parceiroId` ASC),
  INDEX `fk_conta_contaBancaria1_idx` (`contaBancariaId` ASC),
  CONSTRAINT `fk_0a936f08-c6a2-11e4-844e-9439e5f3523b`
    FOREIGN KEY (`empresaId`)
    REFERENCES `metasoft`.`empresa` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_0a9370d4-c6a2-11e4-844e-9439e5f3523b`
    FOREIGN KEY (`loginId`)
    REFERENCES `metasoft`.`login` (`id`),
  CONSTRAINT `fk_conta_centroCusto1`
    FOREIGN KEY (`centroCustoId`)
    REFERENCES `metasoft`.`centroCusto` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_conta_metodoPagamento1`
    FOREIGN KEY (`metodoPagamentoId`)
    REFERENCES `metasoft`.`metodoPagamento` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_conta_parceiro1`
    FOREIGN KEY (`parceiroId`)
    REFERENCES `metasoft`.`parceiro` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_conta_contaBancaria1`
    FOREIGN KEY (`contaBancariaId`)
    REFERENCES `metasoft`.`contaBancaria` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `metasoft`.`impostoNotaFiscal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metasoft`.`impostoNotaFiscal` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `loginId` INT UNSIGNED NOT NULL,
  `empresaId` INT UNSIGNED NOT NULL,
  `criadoEm` DATETIME NOT NULL,
  `imposto` VARCHAR(45) NOT NULL,
  `taxa` DECIMAL(5,5) NOT NULL,
  `deducao` DECIMAL(10,2) NOT NULL,
  `tipoConta` TINYINT(1) NULL,
  `funcTaxa` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_0a93bc9c-c6a2-11e4-844e-9439e5f3523b` (`empresaId` ASC),
  INDEX `fk_0a93be5e-c6a2-11e4-844e-9439e5f3523b` (`loginId` ASC),
  CONSTRAINT `fk_0a93bc9c-c6a2-11e4-844e-9439e5f3523b`
    FOREIGN KEY (`empresaId`)
    REFERENCES `metasoft`.`empresa` (`id`),
  CONSTRAINT `fk_0a93be5e-c6a2-11e4-844e-9439e5f3523b`
    FOREIGN KEY (`loginId`)
    REFERENCES `metasoft`.`login` (`id`));


-- -----------------------------------------------------
-- Table `metasoft`.`parcela`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metasoft`.`parcela` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `valor` DECIMAL(10,2) NOT NULL,
  `deducao` DECIMAL(10,2) NULL,
  `tipoConta` TINYINT(1) NOT NULL,
  `contaId` INT UNSIGNED NOT NULL,
  `pago` TINYINT(1) NOT NULL,
  `empresaId` INT UNSIGNED NOT NULL,
  `impostoNotaFiscalId` INT UNSIGNED NULL,
  `contaBancariaId` INT UNSIGNED NOT NULL,
  `metodoPagamentoId` INT UNSIGNED NOT NULL,
  `dataVencimento` DATETIME NULL,
  `dataPagamento` DATETIME NULL,
  `descricao` VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_put_entry1_idx` (`contaId` ASC),
  INDEX `fk_parcela_empresa1_idx` (`empresaId` ASC),
  INDEX `fk_parcela_impostoNotaFiscal1_idx` (`impostoNotaFiscalId` ASC),
  INDEX `fk_parcela_contaBancaria1_idx` (`contaBancariaId` ASC),
  INDEX `fk_parcela_metodoPagamento1_idx` (`metodoPagamentoId` ASC),
  CONSTRAINT `fk_put_entry1`
    FOREIGN KEY (`contaId`)
    REFERENCES `metasoft`.`conta` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_parcela_empresa1`
    FOREIGN KEY (`empresaId`)
    REFERENCES `metasoft`.`empresa` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_parcela_impostoNotaFiscal1`
    FOREIGN KEY (`impostoNotaFiscalId`)
    REFERENCES `metasoft`.`impostoNotaFiscal` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_parcela_contaBancaria1`
    FOREIGN KEY (`contaBancariaId`)
    REFERENCES `metasoft`.`contaBancaria` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_parcela_metodoPagamento1`
    FOREIGN KEY (`metodoPagamentoId`)
    REFERENCES `metasoft`.`metodoPagamento` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `metasoft`.`transferencia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metasoft`.`transferencia` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `valor` DECIMAL(10,2) NOT NULL,
  `data` DATETIME NOT NULL,
  `cancelado` TINYINT(1) NOT NULL DEFAULT 0,
  `contaBancariaOrigemId` INT UNSIGNED NULL,
  `contaBancariaDestinoId` INT UNSIGNED NULL,
  `loginId` INT UNSIGNED NOT NULL,
  `parcelaId` INT UNSIGNED NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_transferencia_contaBancaria1_idx` (`contaBancariaOrigemId` ASC),
  INDEX `fk_transferencia_contaBancaria2_idx` (`contaBancariaDestinoId` ASC),
  INDEX `fk_transferencia_login1_idx` (`loginId` ASC),
  INDEX `fk_transferencia_parcela1_idx` (`parcelaId` ASC),
  CONSTRAINT `fk_transferencia_contaBancaria1`
    FOREIGN KEY (`contaBancariaOrigemId`)
    REFERENCES `metasoft`.`contaBancaria` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transferencia_contaBancaria2`
    FOREIGN KEY (`contaBancariaDestinoId`)
    REFERENCES `metasoft`.`contaBancaria` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transferencia_login1`
    FOREIGN KEY (`loginId`)
    REFERENCES `metasoft`.`login` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transferencia_parcela1`
    FOREIGN KEY (`parcelaId`)
    REFERENCES `metasoft`.`parcela` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metasoft`.`contrato`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metasoft`.`contrato` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `descritivo` TEXT NULL,
  `statusId` INT NOT NULL,
  `dataAssinatura` DATE NOT NULL,
  `pdf` VARCHAR(255) NULL,
  `contaId` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_contrato_conta1_idx` (`contaId` ASC),
  CONSTRAINT `fk_contrato_conta1`
    FOREIGN KEY (`contaId`)
    REFERENCES `metasoft`.`conta` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'status - aprovando orcamento, em desenvolvimento, finalizado, cancelado, suspenso';


-- -----------------------------------------------------
-- Table `metasoft`.`colaborador`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metasoft`.`colaborador` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `cep` VARCHAR(20) NULL,
  `endereco` VARCHAR(255) NULL,
  `telefone` VARCHAR(45) NULL,
  `salario` DECIMAL(10,2) NOT NULL,
  `dataContratacao` DATE NOT NULL,
  `cpf` VARCHAR(20) NOT NULL,
  `email` VARCHAR(100) NULL,
  `sexo` VARCHAR(1) NOT NULL,
  `dataNascimento` DATE NULL,
  `rg` VARCHAR(20) NULL,
  `orgaoExpedidor` VARCHAR(10) NULL,
  `pis` VARCHAR(45) NULL,
  `carteiraProfissional` VARCHAR(45) NULL,
  `observacao` TEXT NULL,
  `inss` DECIMAL(10,2) NULL,
  `impostoRetido` DECIMAL(10,2) NULL,
  `empresaId` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_colaborador_empresa1_idx` (`empresaId` ASC),
  CONSTRAINT `fk_colaborador_empresa1`
    FOREIGN KEY (`empresaId`)
    REFERENCES `metasoft`.`empresa` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metasoft`.`folhaPagamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metasoft`.`folhaPagamento` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `colaboradorId` INT UNSIGNED NOT NULL,
  `contaId` INT UNSIGNED NOT NULL,
  `mes` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_colaborador_has_conta_conta1_idx` (`contaId` ASC),
  INDEX `fk_colaborador_has_conta_colaborador1_idx` (`colaboradorId` ASC),
  CONSTRAINT `fk_colaborador_has_conta_colaborador1`
    FOREIGN KEY (`colaboradorId`)
    REFERENCES `metasoft`.`colaborador` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_colaborador_has_conta_conta1`
    FOREIGN KEY (`contaId`)
    REFERENCES `metasoft`.`conta` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metasoft`.`item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metasoft`.`item` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `unidade` VARCHAR(45) NULL,
  `patrimonio` TINYINT(1) NOT NULL,
  `taxaDepreciacao` DECIMAL(3,2) NULL,
  `empresaId` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_item_empresa1_idx` (`empresaId` ASC),
  CONSTRAINT `fk_item_empresa1`
    FOREIGN KEY (`empresaId`)
    REFERENCES `metasoft`.`empresa` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metasoft`.`estoque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metasoft`.`estoque` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `itemId` INT UNSIGNED NOT NULL,
  `quantidade` DECIMAL(10,3) NULL,
  `valorUnitario` DECIMAL(10,2) NULL,
  `centroCustoId` INT UNSIGNED NOT NULL,
  `dataAquisicao` DATETIME NOT NULL,
  `loginId` INT UNSIGNED NOT NULL,
  `parceiroId` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_estoque_item1_idx` (`itemId` ASC),
  INDEX `fk_estoque_centroCusto1_idx` (`centroCustoId` ASC),
  INDEX `fk_estoque_login1_idx` (`loginId` ASC),
  INDEX `fk_estoque_parceiro1_idx` (`parceiroId` ASC),
  CONSTRAINT `fk_estoque_item1`
    FOREIGN KEY (`itemId`)
    REFERENCES `metasoft`.`item` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_estoque_centroCusto1`
    FOREIGN KEY (`centroCustoId`)
    REFERENCES `metasoft`.`centroCusto` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_estoque_login1`
    FOREIGN KEY (`loginId`)
    REFERENCES `metasoft`.`login` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_estoque_parceiro1`
    FOREIGN KEY (`parceiroId`)
    REFERENCES `metasoft`.`parceiro` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metasoft`.`transferenciaEstoque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metasoft`.`transferenciaEstoque` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `estoqueSaidaId` INT UNSIGNED NOT NULL,
  `estoqueEntradaId` INT UNSIGNED NOT NULL,
  `quantidade` DECIMAL(10,3) NOT NULL,
  `dataTransferencia` DATETIME NOT NULL,
  `loginId` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_transferenciaEstoque_estoque1_idx` (`estoqueSaidaId` ASC),
  INDEX `fk_transferenciaEstoque_estoque2_idx` (`estoqueEntradaId` ASC),
  INDEX `fk_transferenciaEstoque_login1_idx` (`loginId` ASC),
  CONSTRAINT `fk_transferenciaEstoque_estoque1`
    FOREIGN KEY (`estoqueSaidaId`)
    REFERENCES `metasoft`.`estoque` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transferenciaEstoque_estoque2`
    FOREIGN KEY (`estoqueEntradaId`)
    REFERENCES `metasoft`.`estoque` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transferenciaEstoque_login1`
    FOREIGN KEY (`loginId`)
    REFERENCES `metasoft`.`login` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metasoft`.`produtoCategoria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metasoft`.`produtoCategoria` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `empresaId` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `empresaId`),
  INDEX `fk_produtoCategoria_empresa1_idx` (`empresaId` ASC),
  CONSTRAINT `fk_produtoCategoria_empresa1`
    FOREIGN KEY (`empresaId`)
    REFERENCES `metasoft`.`empresa` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `metasoft`.`produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `metasoft`.`produto` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `codigo` VARCHAR(45) NULL,
  `preco` DECIMAL(10,2) NOT NULL,
  `produtoCategoriaId` INT UNSIGNED NOT NULL,
  `empresaId` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `empresaId`),
  INDEX `fk_produto_produtoCategoria1_idx` (`produtoCategoriaId` ASC),
  INDEX `fk_produto_empresa1_idx` (`empresaId` ASC),
  CONSTRAINT `fk_produto_produtoCategoria1`
    FOREIGN KEY (`produtoCategoriaId`)
    REFERENCES `metasoft`.`produtoCategoria` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_produto_empresa1`
    FOREIGN KEY (`empresaId`)
    REFERENCES `metasoft`.`empresa` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `metasoft`.`empresa`
-- -----------------------------------------------------
START TRANSACTION;
USE `metasoft`;
INSERT INTO `metasoft`.`empresa` (`id`, `cnpj`, `nome`, `nomeFantasia`, `estado`, `cidade`, `endereco`, `cep`) VALUES (1, '000000000000000', 'System', 'System', 'None', 'None', 'None', '000000000');

COMMIT;


-- -----------------------------------------------------
-- Data for table `metasoft`.`login`
-- -----------------------------------------------------
START TRANSACTION;
USE `metasoft`;
INSERT INTO `metasoft`.`login` (`id`, `login`, `senha`, `nome`, `papel`, `empresaId`) VALUES (1, 'admin', 'admin', 'Admin', 'admin', 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `metasoft`.`centroCusto`
-- -----------------------------------------------------
START TRANSACTION;
USE `metasoft`;
INSERT INTO `metasoft`.`centroCusto` (`id`, `empresaId`, `nome`) VALUES (NULL, 1, 'Rio Vermelho');
INSERT INTO `metasoft`.`centroCusto` (`id`, `empresaId`, `nome`) VALUES (NULL, 1, 'STIEP');
INSERT INTO `metasoft`.`centroCusto` (`id`, `empresaId`, `nome`) VALUES (NULL, 1, 'Barra');

COMMIT;


-- -----------------------------------------------------
-- Data for table `metasoft`.`contaBancaria`
-- -----------------------------------------------------
START TRANSACTION;
USE `metasoft`;
INSERT INTO `metasoft`.`contaBancaria` (`id`, `empresaId`, `saldo`, `banco`, `agencia`, `conta`) VALUES (NULL, 1, 2040.94, '001', '4289-2', '92980-2');
INSERT INTO `metasoft`.`contaBancaria` (`id`, `empresaId`, `saldo`, `banco`, `agencia`, `conta`) VALUES (NULL, 1, -399.40, '002', '9293-x', '19304-3');

COMMIT;


-- -----------------------------------------------------
-- Data for table `metasoft`.`metodoPagamento`
-- -----------------------------------------------------
START TRANSACTION;
USE `metasoft`;
INSERT INTO `metasoft`.`metodoPagamento` (`id`, `nome`, `empresaId`) VALUES (NULL, 'Dinheiro', 1);
INSERT INTO `metasoft`.`metodoPagamento` (`id`, `nome`, `empresaId`) VALUES (NULL, 'Débito', 1);
INSERT INTO `metasoft`.`metodoPagamento` (`id`, `nome`, `empresaId`) VALUES (NULL, 'Crédito', 1);
INSERT INTO `metasoft`.`metodoPagamento` (`id`, `nome`, `empresaId`) VALUES (NULL, 'Transferência', 1);

COMMIT;

