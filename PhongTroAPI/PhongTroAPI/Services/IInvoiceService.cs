using System.Collections.Generic;
using System.Threading.Tasks;
using PhongTroAPI.DTOs;

namespace PhongTroAPI.Services;

public interface IInvoiceService
{
    Task<List<InvoiceDto>> GetInvoicesAsync(int? month, int? year);
    Task<List<InvoiceDto>> GetInvoicesByCustomerAsync(int maKhach);
    Task<InvoiceDto?> GetInvoiceByIdAsync(int id);
    Task<InvoiceDto> CreateInvoiceAsync(InvoiceCreateDto createDto);
    Task<bool> UpdateInvoiceStatusAsync(int id, InvoiceUpdateStatusDto updateDto);
    Task<bool> DeleteInvoiceAsync(int id);
}
